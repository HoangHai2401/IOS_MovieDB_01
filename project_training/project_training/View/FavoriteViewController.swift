//
//  FavoriteViewController.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/29/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {
    var favoriteList = [Movie]()

    @IBOutlet weak var favoriteTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getData() {
        favoriteList = HandlingMovieDatabase.fetchMovie()
        favoriteTableView.reloadData()
    }

    func setView() {
        let nib = UINib(nibName: "FavoriteTableViewCell", bundle: nil)
        favoriteTableView.register(nib, forCellReuseIdentifier: "FavoriteTableViewCell")
        navigationItem.title = "Favorite Movies"
        if favoriteList.isEmpty {
            favoriteTableView.isHidden = true
        } else {
            favoriteTableView.isHidden = false
        }
    }
}

// MARK: extension UITableViewDelegate for genresTableview and autocompleteTableView in MainViewController
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(tableView.bounds.width * 1.2) / CGFloat(Common.cellsPerRow)
        return height
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if HandlingMovieDatabase.deleteMovie(movie: favoriteList[indexPath.row]) {
                self.favoriteList.remove(at: indexPath.row)
                self.favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(
            withIdentifier: "detailViewController") as? DetailMovieViewController else {
                return
        }
        viewController.movieData = self.favoriteList[indexPath.row]
        print(favoriteList[indexPath.row].movieId ?? 0)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: extension UITableViewDataSource for genresTableview and autocompleteTableView in MainViewController
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FavoriteTableViewCell") as? FavoriteTableViewCell else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FavoriteTableViewCell", for: indexPath)
            return cell
        }
        cell.setContentForCell(movie: favoriteList[indexPath.row])
        return cell
    }
}
