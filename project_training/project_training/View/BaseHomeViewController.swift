//
//  BaseHomeViewController.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class BaseHomeViewController: UIViewController, AlertViewControllerExtension {
    var searchList = [String]()
    var defaultPage = 1
    var searchMovieList = [Movie]()

    let autocompleteTableView = UITableView()
    let nameNavigationLabel = UILabel()
    let searchBar = CustomTextField()
    private let movieRepository: MovieRepository = MovieRepositoryImpl(api: ApiService.share)

    lazy var sideBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "btn_left")?.withRenderingMode(.alwaysOriginal),
                               style: .plain, target: self, action: #selector(onSidebarButtonClicked(sender:)))
    }()

    lazy var searchBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal),
                               style: .plain, target: self, action: #selector(addSearchAction(sender:)))
    }()

    lazy var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel",
                               style: .plain, target: self, action: #selector(addCancelAction(sender:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setSearchResultTableView()
    }

    private func setView() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = self.sideBarButton
        self.navigationItem.rightBarButtonItem = self.searchBarButton
        navigationItem.title = Common.appName
        setSearchBar()
    }

    private func setSearchBar() {
        searchBar.backgroundColor = .white
        let heightSearchBar = 35
        let widthSearchBar = view.frame.width
        searchBar.frame = CGRect(x: 0, y: 0, width: Int(widthSearchBar), height: heightSearchBar)
        searchBar.attributedPlaceholder = NSAttributedString(
            string: " Search...", attributes: [NSForegroundColorAttributeName: UIColor.black])
        searchBar.roundCorners(radius: 8)
        searchBar.image = UIImage(named: "searchblack")
        searchBar.awakeFromNib()
        searchBar.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func searchData(query: String) {
        movieRepository.searchMovieByQuery(query: query, page: defaultPage) { result in
            switch result {
            case .success(let MovieListByQueryResponse):
                self.searchMovieList = (MovieListByQueryResponse?.movieList)!
                for item in (MovieListByQueryResponse?.movieList)! {
                    self.searchList.append(item.title!)
                }
                let height = self.autocompleteTableView.contentSize.height > self.view.frame.height ?
                    self.view.frame.height / 3 : self.autocompleteTableView.contentSize.height
                self.autocompleteTableView.frame = CGRect(x: self.autocompleteTableView.frame.origin.x,
                                                          y: self.autocompleteTableView.frame.origin.y + 5,
                                                          width: self.autocompleteTableView.frame.size.width,
                                                          height: height)
                DispatchQueue.main.async {
                    self.autocompleteTableView.reloadData()
                }
            case .failure(let error):
                self.showErrorAlert(message: error?.errorMessage)
            }
        }
    }

    private func setSearchResultTableView() {
        let LocationX = 5
        let LocationY = 64
        let width = Int(view.frame.width * 4 / 5)
        let height = Int(view.frame.height * 2 / 5)
        autocompleteTableView.frame = CGRect(x: LocationX, y: LocationY, width: width, height: height)
        autocompleteTableView.isHidden = true
        autocompleteTableView.isScrollEnabled = true
        view.addSubview(autocompleteTableView)
    }
}

extension BaseHomeViewController: UITextFieldDelegate {
}
