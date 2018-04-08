//
//  BaseViewController.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private lazy var backBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_toolbar")?.withRenderingMode(.alwaysOriginal),
                               style: .plain, target: self, action: #selector(onSidebarButtonClicked(sender:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = self.backBarButton
    }

    func onSidebarButtonClicked(sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
}
