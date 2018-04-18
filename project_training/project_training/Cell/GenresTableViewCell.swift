//
//  GenresTableViewCell.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/30/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

protocol GenresTableViewCellDelegate: AnyObject {
    func moreButtonTapped(cell: GenresTableViewCell)
}

class GenresTableViewCell: UITableViewCell {
    var listMovieOfGenre = [Movie]()
    var defaultPage = 1
    weak var delegate: GenresTableViewCellDelegate?

    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: ApiService.share)

    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var collectionViewInTable: UICollectionView!
    @IBOutlet weak var moreMovieGenresButton: UIButton!

    @IBAction func displayMoreMovieGenres(_ sender: Any) {
        delegate?.moreButtonTapped(cell: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionViewInTable()
    }

    func setContentForCell(index: Int) {
        setElementForCell(sectionName: Common.listGenres[index].1)
        movieRepository.getMovieByGenres(genresId: Common.listGenres[index].0, page: defaultPage) { result in
            switch result {
            case .success(let MovieListByGenresResponse):
                guard let movieList = MovieListByGenresResponse?.movieList else {
                    return
                }
                self.listMovieOfGenre = movieList
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

    func setElementForCell(sectionName: String) {
        moreMovieGenresButton.layer.cornerRadius = 3
        moreMovieGenresButton.clipsToBounds = true
        sectionLabel.text = sectionName
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
            + (flowLayout.minimumInteritemSpacing * CGFloat(Common.cellsPerRow - 1))
        let width = Int((collectionView.bounds.width - totalSpace) / CGFloat(Common.cellsPerRow))
        let height = Int((collectionView.bounds.width*1.5) / CGFloat(Common.cellsPerRow))
        return CGSize(width: width, height: height)
    }
}
