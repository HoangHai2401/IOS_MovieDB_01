//
//  GenresTableViewCell.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/30/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class GenresTableViewCell: UITableViewCell {
    var listMovieOfGenre = [Movie]()
    let cellsPerRow = 3
    var defaultPage = 1
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: ApiService.share)

    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var collectionViewInTable: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionViewInTable()
    }

    func setContentForCell(genresId: Int) {
        movieRepository.getMovieByGenres(genresId: genresId, page: defaultPage) { result in
            switch result {
            case .success(let MovieListByGenresResponse):
                self.listMovieOfGenre = (MovieListByGenresResponse?.movieList)!
            case .failure(let error):
                print((error?.errorMessage)!)
            }
            DispatchQueue.main.async {
                self.collectionViewInTable.reloadData()
            }
        }
    }

    func setCollectionViewInTable() {
        collectionViewInTable.dataSource = self
        collectionViewInTable.delegate = self
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionViewInTable.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
}

// MARK: extension UICollectionViewDataSource for collectionViewInTable in GenresTableViewCell
extension GenresTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMovieOfGenre.count
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
        cell.setContentForCell(movie: listMovieOfGenre[indexPath.row])
        return cell
    }
}

// MARK: extension UICollectionViewDelegateFlowLayout for collectionViewInTable in GenresTableViewCell
extension GenresTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1))
        let width = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        let height = Int((collectionView.bounds.width*1.5) / CGFloat(cellsPerRow))
        return CGSize(width: width, height: height)
    }
}
