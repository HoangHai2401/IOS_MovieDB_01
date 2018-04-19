//
//  GenresMovieViewController.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/19/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class GenresMovieViewController: BaseViewController, AlertViewControllerExtension {
    var genres: (Int, String)?
    var movieList = [Movie]()
    var defaultPage = 1
    fileprivate var activityIndicator: LoadMoreActivityIndicator!

    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: ApiService.share)

    @IBOutlet weak var movieCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setView() {
        setCollectionView()
        guard let genres = genres else {
            return
        }
        getData(genresId: genres.0)
        navigationItem.title = genres.1
        activityIndicator = LoadMoreActivityIndicator(collectionView: movieCollectionView,
                                                      spacingFromLastCell: 10,
                                                    spacingFromCellwhenLoadMore: 60)
    }

    func setCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        movieCollectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }

    func loadmore() {
        defaultPage += 1
        guard let genres = genres else {
            return
        }
        getData(genresId: genres.0)
    }

    func getData(genresId: Int) {
        movieRepository.getMovieByGenres(genresId: genresId, page: defaultPage) { result in
            switch result {
            case .success(let MovieListByGenresResponse):
                guard let movieList = MovieListByGenresResponse?.movieList else {
                    return
                }
                self.movieList += movieList
            case .failure(let error):
                print((error?.errorMessage)!)
            }
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
}

// MARK: extension UICollectionViewDelegate for movieCollectionView in MainViewController
extension GenresMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(
            withIdentifier: "detailViewController") as? DetailMovieViewController else {
                return
        }
        viewController.movieData = self.movieList[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
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
extension GenresMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell",
                                                            for: indexPath) as? MovieCollectionViewCell else {
                                                                let cell = collectionView.dequeueReusableCell(
                                                                    withReuseIdentifier: "MovieCollectionViewCell",
                                                                    for: indexPath)
                                                                return cell
        }
        if movieList.count > indexPath.row {
            cell.setContentForCell(movie: movieList[indexPath.row])
        }
        return cell
    }
}

// MARK: extension UICollectionViewDelegateFlowLayout for movieCollectionView in MainViewController
extension GenresMovieViewController: UICollectionViewDelegateFlowLayout {
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
