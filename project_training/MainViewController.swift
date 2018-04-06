//
//  MainViewController.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: BaseHomeViewController, AlertViewControllerExtension {
    let heightForLabelCell = 50
    let cellsPerRow = 3
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: ApiService.share)

    var movieList = [Movie]()
    var listMovieOfGenres = [(String, [Movie])]()
    var defaultPage = 1
    fileprivate var activityIndicator: LoadMoreActivityIndicator!

    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var genresTableView: UITableView!

    @IBAction func segmentSelected(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            displayPopularMovies()
        case 1:
            displayUpcomingMovies()
        case 2:
            displayTopRatedMovies()
        case 3:
            displayGenresMovies()
        case 4:
            displayNowPlayingMovies()
        default:
            break
        }
        categorySegment.changeUnderlinePosition()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    func getdata(url: String) {
        movieRepository.getMovieByCategory(categoryUrl: url, page: defaultPage) { result in
                switch result {
                case .success(let MovieListByCategoryResponse):
                    self.movieList = (MovieListByCategoryResponse?.movieList)!
                case .failure(let error):
                    self.showErrorAlert(message: error?.errorMessage)
                }
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }

    func prepareView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        genresTableView.delegate = self
        genresTableView.dataSource = self
        categorySegment.apportionsSegmentWidthsByContent = true
        categorySegment.addUnderlineForSelectedSegment()
        for item in 0...4 {
            categorySegment.setTitle(Common.listCategory[item].0, forSegmentAt: item)
        }
        self.navigationController?.navigationItem.title = "IOS_DB01"
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        movieCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        getdata(url: Urls.popularUrl)
        genresTableView.isHidden = true
        movieCollectionView.isHidden = false
        activityIndicator = LoadMoreActivityIndicator(collectionView: movieCollectionView,
                                                      spacingFromLastCell: 10,
                                                      spacingFromCellwhenLoadMore: 60)
    }

    func displayPopularMovies() {
        defaultPage = 1
        movieList.removeAll()
        getdata(url: Urls.popularUrl)
        genresTableView.isHidden = true
        movieCollectionView.isHidden = false
    }

    func displayUpcomingMovies() {
        defaultPage = 1
        movieList.removeAll()
        getdata(url: Urls.upcomingUrl)
        genresTableView.isHidden = true
        movieCollectionView.isHidden = false
    }

    func displayNowPlayingMovies() {
        defaultPage = 1
        movieList.removeAll()
        getdata(url: Urls.nowPlayingUrl)
        genresTableView.isHidden = true
        movieCollectionView.isHidden = false
    }

    func displayTopRatedMovies() {
        defaultPage = 1
        movieList.removeAll()
        getdata(url: Urls.topRatedUrl)
        genresTableView.isHidden = true
        movieCollectionView.isHidden = false
    }

    func displayGenresMovies() {
        defaultPage = 1
        genresTableView.isHidden = false
        movieCollectionView.isHidden = true
    }

    func loadmore() {
        let category = categorySegment.selectedSegmentIndex
        defaultPage += 1
        getdata(url: Common.listCategory[category].1)
    }
}

// MARK: extension UICollectionViewDelegate for movieCollectionView in MainViewController
extension MainViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categorySegment.selectedSegmentIndex == 3 ? Common.listGenres.count : 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
}

// MARK: extension UICollectionViewDataSource for movieCollectionView in MainViewController
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                            for: indexPath) as? MovieCollectionViewCell else {
                                                                let cell = collectionView.dequeueReusableCell(
                                                                    withReuseIdentifier: "cell", for: indexPath)
                                                                return cell
        }
        if movieList.count > indexPath.row {
            cell.setContentForCell(movie: movieList[indexPath.row])
        }
        return cell
    }
}

// MARK: extension UICollectionViewDelegateFlowLayout for genresTableview in MainViewController
extension MainViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: extension UITableViewDelegate for genresTableview in MainViewController
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(tableView.bounds.width * 1.5) / CGFloat(cellsPerRow) + CGFloat(heightForLabelCell)
        return height
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.scrollViewDidScroll(scrollView: scrollView) {
            DispatchQueue.global(qos: .utility).async {
                DispatchQueue.main.async { [weak self] in
                    self?.loadmore()
                    self?.activityIndicator.loadMoreActionFinshed(scrollView: scrollView)
                }
            }
        }
    }
}

// MARK: extension UITableViewDataSource for genresTableview in MainViewController
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Common.listGenres.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "genrescell") as? GenresTableViewCell else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "genrescell", for: indexPath)
            return cell
        }
        cell.setContentForCell(genresId: Common.listGenres[indexPath.row].0)
        cell.sectionLabel.text = Common.listGenres[indexPath.row].1
        return cell
    }
}
