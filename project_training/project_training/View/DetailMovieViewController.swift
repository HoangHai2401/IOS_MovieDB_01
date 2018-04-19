//
//  DetailMovieViewController.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/30/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class DetailMovieViewController: BaseViewController, AlertViewControllerExtension, YTPlayerViewDelegate {
    var movieData: Movie?
    var characterList = [Person]()
    var producerList = [Person]()
    var movieList = [Movie]()
    var trailerList = [Trailer]()
    var heightDescription = 0
    var genresString = ""
    private lazy var favoriteBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal),
                               style: .plain, target: self, action: #selector(favoriteButtonClicked(sender:)))
    }()

    private lazy var unFavoriteBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "hearted")?.withRenderingMode(.alwaysOriginal),
                               style: .plain, target: self, action: #selector(unFavoriteButtonClicked(sender:)))
    }()

    private let personRepository: PersonRepository = PersonRepositoryImpl(api: ApiService.share)
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: ApiService.share)

    @IBOutlet  weak var movieBackgroundImageView: UIImageView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieUserScoreLabel: UILabel!
    @IBOutlet weak var movieOverViewLabel: UILabel!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    @IBOutlet weak var producerCollectionView: UICollectionView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var overviewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var playViewYoutube: YTPlayerView!
    @IBOutlet weak var timeLabel: UILabel!

    @IBAction func seeMoreButtonAction(_ sender: Any) {
        overviewHeightContraint.constant = CGFloat(heightDescription)
        seeMoreButton.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setView() {
        guard let movie = movieData, let movieId = movie.movieId else {
            return
        }
        setCollectionView()
        setNavigation(movie: movie)
        getData(movieId: movieId)
    }

    func setCollectionView() {
        let nib = UINib(nibName: "PersonCollectionViewCell", bundle: nil)
        actorCollectionView.delegate = self
        actorCollectionView.dataSource = self
        actorCollectionView.register(nib, forCellWithReuseIdentifier: "PersonCollectionViewCell")
        producerCollectionView.delegate = self
        producerCollectionView.dataSource = self
        producerCollectionView.register(nib, forCellWithReuseIdentifier: "PersonCollectionViewCell")
    }

    func setNavigation(movie: Movie) {
        self.navigationItem.rightBarButtonItem = self.favoriteBarButton
        if HandlingMovieDatabase.checkData(movie: movie) != nil {
            favoriteBarButton.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = self.unFavoriteBarButton
        }
    }

    func favoriteButtonClicked(sender: AnyObject) {
        guard let movie = movieData else {
            return
        }
        if HandlingMovieDatabase.checkData(movie: movie) == nil {
            if HandlingMovieDatabase.insertMovie(movie: movie) {
                self.navigationItem.rightBarButtonItem = self.unFavoriteBarButton
            }
        }
    }

    func unFavoriteButtonClicked(sender: AnyObject) {
        guard let movie = movieData else {
            return
        }
        if HandlingMovieDatabase.checkData(movie: movie) != nil {
            if HandlingMovieDatabase.deleteMovie(movie: movie) {
                self.navigationItem.rightBarButtonItem = self.favoriteBarButton
            }
        }
    }

    func getPersonByMovie(movieId: Int) {
        personRepository.getPersonByMovie(movieId: movieId, page: 1) { result in
            switch result {
            case .success(let dataList):
                if let castList = dataList?.castList {
                    self.characterList += castList
                }
                if let crewList = dataList?.crewList {
                    self.producerList += crewList
                }
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
                self.hideLoading()
            }
            DispatchQueue.main.async {
                self.actorCollectionView.reloadData()
                self.producerCollectionView.reloadData()
                self.hideLoading()
            }
        }
    }

    func getMovieTrailer(movieId: Int) {
        movieRepository.getMovieTrailer(movieId: movieId, page: 1) { result in
            switch result {
            case .success(let dataList):
                if let trailerList = dataList?.trailerList {
                    DispatchQueue.main.async {
                        self.playViewYoutube.delegate = self
                        let playerVars = ["playsinline": 1]
                        if !trailerList.isEmpty, let movieKey = trailerList[0].trailerKey {
                            self.playViewYoutube.load(withVideoId: movieKey, playerVars: playerVars)
                        }
                        self.hideLoading()
                    }
                }
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
                self.hideLoading()
            }
        }
    }

    func getMovieDetail(movieId: Int) {
        movieRepository.getMovieDetail(movieId: movieId, page: 1) { result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    self.setDataForView(movie: movie)
                    self.hideLoading()
                }
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
                self.hideLoading()
            }
        }
    }

    func setDataForView(movie: Movie?) {
        if let imageUrl = movie?.getFullLink(),
            let imageBackDropUrl = movie?.getFullLinkBackDropPath() {
            self.movieImageView.downloadedFrom(link: imageUrl)
            self.movieBackgroundImageView.downloadedFrom(link: imageBackDropUrl)
        }
        self.movieImageView.contentMode = .scaleToFill
        self.movieBackgroundImageView.contentMode = .scaleAspectFill
        self.movieBackgroundImageView.tintColor = UIColor.gray
        self.movieNameLabel.text = movie?.originalTitle
        if let voteAverage = movie?.voteAverage {
            self.movieUserScoreLabel.text = String(format: "%.1f", voteAverage) + "/10"
        }
        let description = movie?.overview  ?? Common.defaultResult
        let descriptionBounds = TextSize.size(description,
                                              font: UIFont.systemFont(ofSize: 13.0),
                                              width: self.descriptionView.frame.width)
        if descriptionBounds.height > 70 {
            self.seeMoreButton.isHidden = false
            self.heightDescription = Int(descriptionBounds.height)
        } else {
            self.seeMoreButton.isHidden = true
            self.overviewHeightContraint.constant = descriptionBounds.height
        }
        self.movieOverViewLabel.text = description != "" ? description : Common.defaultResult
        self.movieOverViewLabel.text = movie?.overview
        if let originalLanguage = movie?.originalLanguage,
            let releaseDate = movie?.releaseDate, let time = movie?.runTime {
            self.originalLanguageLabel.text = "Language: " + originalLanguage
            self.releaseDateLabel.text = releaseDate
            self.timeLabel.text = "\(time) min"
        }
        if let genresList = movie?.genres {
            for item in genresList {
                self.genresString += item.name! + "     "
            }
        }
        self.genresLabel.text = self.genresString
        self.navigationItem.title = movie?.title
    }

    func getData(movieId: Int) {
        self.showLoadingOnParent()
        getPersonByMovie(movieId: movieId)
        getMovieTrailer(movieId: movieId)
        getMovieDetail(movieId: movieId)
    }
}

// MARK: extension UICollectionViewDelegate for actorCollectionView in DetailMovieViewController
extension DetailMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(
            withIdentifier: "personDetail") as? PersonDetailViewController
        if collectionView == actorCollectionView {
            viewController?.personId = self.characterList[indexPath.row].personId
        }
        if collectionView == producerCollectionView {
            viewController?.personId = self.producerList[indexPath.row].personId
        }
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}

// MARK: extension UICollectionViewDataSource for actorCollectionView in DetailMovieViewController
extension DetailMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int?
        if collectionView == actorCollectionView {
            count = characterList.count > Common.numberCellInRow ? Common.numberCellInRow : characterList.count
        }
        if collectionView == producerCollectionView {
             count = producerList.count > Common.numberCellInRow ? Common.numberCellInRow : producerList.count
        }
        return count!
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellToReturn = UICollectionViewCell()
        if collectionView == actorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionViewCell",
                                                                for: indexPath) as? PersonCollectionViewCell else {
                                                                    let cell = collectionView.dequeueReusableCell(
                                                                        withReuseIdentifier: "PersonCollectionViewCell",
                                                                        for: indexPath)
                                                                    cellToReturn = cell
                                                                    return cell
            }
            if characterList.count > indexPath.row {
                cell.setContentOfCell(person: characterList[indexPath.row])
            }
            return cell
        }
        if collectionView == producerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionViewCell",
                                                                for: indexPath) as? PersonCollectionViewCell else {
                                                                    let cell = collectionView.dequeueReusableCell(
                                                                        withReuseIdentifier: "PersonCollectionViewCell",
                                                                        for: indexPath)
                                                                    cellToReturn = cell
                                                                    return cell
            }
            if characterList.count > indexPath.row {
                cell.setContentOfCell(person: producerList[indexPath.row])
            }
            return cell
        }
        return cellToReturn
    }
}

// MARK: extension UICollectionViewDelegateFlowLayout for actorCollectionView in DetailMovieViewController
extension DetailMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(Common.numberCellInRow - 1))
        let width = Int(CGFloat(collectionView.bounds.width - totalSpace) / CGFloat(Common.numberCellInRow))
        let height = Int(CGFloat(collectionView.bounds.width * 1.5) / CGFloat(Common.numberCellInRow))
        return CGSize(width: width, height: height)
    }
}
