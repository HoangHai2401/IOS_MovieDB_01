//
//  MainViewController.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class MainViewController: BaseHomeViewController {
    let heightForLabelCell = 50
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: ApiService.share)

    var movieList = [Movie]()
    var listMovieOfGenres = [(String, [Movie])]()
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
        self.showLoadingOnParent()
        movieRepository.getMovieByCategory(categoryUrl: url, page: defaultPage) { result in
            switch result {
            case .success(let movieListByCategoryResponse):
                self.handleSuccessGetMovieByCategory(movieListByCategoryResponse: movieListByCategoryResponse)
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
                self.hideLoading()
            }
        }
    }

    func handleSuccessGetMovieByCategory(movieListByCategoryResponse: MovieListByCategoryResponse?) {
        guard let movieListByCategory = movieListByCategoryResponse?.movieList else {
            return
        }
        self.movieList += movieListByCategory
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
            self.hideLoading()
        }
    }

    func prepareView() {
        setSegment()
        setTableView()
        setNavigation()
        setCollectionView()
        getdata(url: Urls.popularUrl)
        activityIndicator = LoadMoreActivityIndicator(collectionView: movieCollectionView,
                                                      spacingFromLastCell: 10,
                                                      spacingFromCellwhenLoadMore: 60)
    }

    func setCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        movieCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        movieCollectionView.isHidden = false
    }

    func setSegment() {
        categorySegment.apportionsSegmentWidthsByContent = true
        categorySegment.addUnderlineForSelectedSegment()
        for item in 0...Common.totalTabInSegment {
            categorySegment.setTitle(Common.listCategory[item].0, forSegmentAt: item)
        }
    }

    func setNavigation() {
        navigationItem.title = Common.titleMainNavigation
    }

    func setTableView() {
        genresTableView.delegate = self
        genresTableView.dataSource = self
        super.autocompleteTableView.delegate = self
        super.autocompleteTableView.dataSource = self
        super.autocompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchcell")
        genresTableView.isHidden = true
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
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(
            withIdentifier: "detailViewController") as? DetailMovieViewController
        viewController?.movieData = self.movieList[indexPath.row]
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.movieCollectionView {
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
            + (flowLayout.minimumInteritemSpacing * CGFloat(Common.cellsPerRow - 1))
        let width = Int(CGFloat(collectionView.bounds.width - totalSpace) / CGFloat(Common.cellsPerRow))
        let height = Int(CGFloat(collectionView.bounds.width * 1.5) / CGFloat(Common.cellsPerRow))
        return CGSize(width: width, height: height)
    }
}

// MARK: extension UITableViewDelegate for genresTableview and autocompleteTableView in MainViewController
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightCell: CGFloat?
        if tableView == self.genresTableView {
            let height = CGFloat(tableView.bounds.width * 1.5) /
                CGFloat(Common.cellsPerRow) + CGFloat(heightForLabelCell)
            heightCell = height
        }
        if tableView == super.autocompleteTableView {
            let height = CGFloat(heightForLabelCell)
            heightCell = height
        }
        return heightCell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == super.autocompleteTableView {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let viewController = storyBoard.instantiateViewController(
                withIdentifier: "detailViewController") as? DetailMovieViewController else {
                    return
            }
            viewController.movieData = super.searchMovieList[indexPath.row]
            super.autocompleteTableView.isHidden = true
            super.searchBar.text = ""
            super.searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: extension UITableViewDataSource for genresTableview and autocompleteTableView in MainViewController
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if tableView == self.genresTableView {
            count = Common.listGenres.count
        }
        if tableView == super.autocompleteTableView {
            count =  super.searchList.count
        }
        return count!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        if tableView == self.genresTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "genrescell") as? GenresTableViewCell else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "genrescell", for: indexPath)
                cellToReturn = cell
                return cell
            }
            cell.delegate = self
            cell.setContentForCell(index: indexPath.row)
            return cell
        }
        if tableView == super.autocompleteTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell") else {
                return UITableViewCell()
            }
            if searchList.count > indexPath.row {
                cell.textLabel?.text = super.searchList[indexPath.row]
                cellToReturn = cell
            }
            return cell
        }
        return cellToReturn
    }
}

// MARK: extension GenresTableViewCellDelegate for genresTableview and autocompleteTableView in MainViewController
extension MainViewController: GenresTableViewCellDelegate {
    func moreButtonTapped(cell: GenresTableViewCell) {
        guard let indexPath = self.genresTableView.indexPath(for: cell) else {
            return
        }
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(
            withIdentifier: "genresMovieViewController") as? GenresMovieViewController else {
                return
        }
        viewController.genres = Common.listGenres[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
