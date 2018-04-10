//
//  DetailMovieViewController.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/30/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class DetailMovieViewController: BaseViewController, AlertViewControllerExtension {
    var movieData: Movie?
    var characterList = [Person]()
    var crewList = [Person]()
    var heightDescription = 0
    var genresString = ""

    let cellsPerRow = 5
    private let personRepository: PersonRepository = PersonRepositoryImpl(api: ApiService.share)

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieUserScoreLabel: UILabel!
    @IBOutlet weak var movieOverViewLabel: UILabel!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var overviewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!

    @IBAction func trailerButtonAction(_ sender: Any) {
    }
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
        if let movie = movieData {
            if let imageUrl = movie.getFullLink() {
                movieImageView.downloadedFrom(link: imageUrl)
            }
            movieImageView.contentMode = .scaleToFill
            movieNameLabel.text = movie.originalTitle
            let movieVoteAverage = String(format: "%.1f", movie.voteAverage!)
            movieUserScoreLabel.text = movieVoteAverage
            if let description = movie.overview {
                let descriptionBounds = TextSize.size(description,
                                                      font: UIFont.systemFont(ofSize: 13.0),
                                                      width: descriptionView.frame.width)
                if descriptionBounds.height > 70 {
                    seeMoreButton.isHidden = false
                    heightDescription = Int(descriptionBounds.height)
                } else {
                    seeMoreButton.isHidden = true
                    overviewHeightContraint.constant = descriptionBounds.height
                }
            }
            movieOverViewLabel.text = movie.overview
            if let originalLanguage = movie.originalLanguage, let releaseDate = movie.releaseDate {
                originalLanguageLabel.text = "Original Language:" + originalLanguage
                releaseDateLabel.text = "Release Date: " + releaseDate
            }
            for item in movie.genreIds {
                if let index = Common.listGenres.index(where: {$0.0 == item}) {
                    genresString += Common.listGenres[index].1 + "     "
                }
            }
            genresLabel.text = genresString
            self.navigationController?.navigationItem.title = movie.title
            actorCollectionView.delegate = self
            actorCollectionView.dataSource = self
            let nib = UINib(nibName: "PersonCollectionViewCell", bundle: nil)
            actorCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
            if let movieId = movie.movieId {
                getData(movieId: movieId)
            }
        }
    }

    func getData(movieId: Int) {
        personRepository.getPersonByMovie(movieId: movieId, page: 1) { result in
            switch result {
            case .success(let dataList):
                if let castList = dataList?.castList {
                    self.characterList += castList
                }
                if let crewList = dataList?.crewList {
                    self.crewList += crewList
                }
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
            }
            DispatchQueue.main.async {
                self.actorCollectionView.reloadData()
            }
        }
    }
}

// MARK: extension UICollectionViewDelegate for actorCollectionView in DetailMovieViewController
extension DetailMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: extension UICollectionViewDataSource for actorCollectionView in DetailMovieViewController
extension DetailMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(characterList.count)
        return characterList.count > 5 ? 5 : characterList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                            for: indexPath) as? PersonCollectionViewCell else {
                                                                let cell = collectionView.dequeueReusableCell(
                                                                    withReuseIdentifier: "cell", for: indexPath)
                                                                return cell
        }
        if characterList.count > indexPath.row {
            cell.setContentOfCell(person: characterList[indexPath.row])
        }
        return cell
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
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1))
        let width = Int(CGFloat(collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        let height = Int(CGFloat(collectionView.bounds.width * 1.5) / CGFloat(cellsPerRow))
        return CGSize(width: width, height: height)
    }
}
