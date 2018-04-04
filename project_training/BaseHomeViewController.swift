//
//  BaseHomeViewController.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class BaseHomeViewController: UIViewController {

    private lazy var sideBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "btn_left")?.withRenderingMode(.alwaysOriginal),
                               style: .plain, target: self, action: #selector(onSidebarButtonClicked(sender:)))
    }()

    private lazy var searchBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal),
                               style: .plain, target: self, action: #selector(addOptionsMenu(sender:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = self.sideBarButton
        self.navigationItem.rightBarButtonItem = self.searchBarButton
    }

    func onSidebarButtonClicked(sender: AnyObject) {
    }

    func addOptionsMenu(sender: AnyObject) {
    }
}
