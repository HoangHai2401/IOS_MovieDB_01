//
//  BaseHomeViewControllerExtension.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/9/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

extension BaseHomeViewController {
    @objc func addSearchAction(sender: UIBarButtonItem) {
        if navigationItem.titleView != searchBar {
            searchBar.isHidden = false
            navigationItem.titleView = searchBar
            searchBar.keyboardType = UIKeyboardType.asciiCapable
            navigationItem.rightBarButtonItem = self.cancelButton
            searchBar.delegate = self
            if let text = searchBar.text, !text.isEmpty {
                searchList.removeAll()
                searchData(query: text)
                autocompleteTableView.isHidden = false
            } else {
                autocompleteTableView.isHidden = true
            }
        }
    }

    @objc func addCancelAction(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = self.searchBarButton
        searchBar.isHidden = true
        autocompleteTableView.isHidden = true
        nameNavigationLabel.text = Common.appName
        navigationItem.titleView = nameNavigationLabel
    }

    @objc func onSidebarButtonClicked(sender: AnyObject) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }

    @objc func textFieldDidChange(_ sender: Any) {
        if let text = searchBar.text, !text.isEmpty {
            searchList.removeAll()
            searchData(query: text)
            autocompleteTableView.isHidden = false
        } else {
            autocompleteTableView.isHidden = true
        }
    }
}
