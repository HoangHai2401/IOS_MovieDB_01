//
//  BaseViewController.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable {
    private lazy var backBarButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "back_toolbar")?.withRenderingMode(.alwaysOriginal),
                               style: .plain, target: self, action: #selector(backButtonClicked(sender:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = self.backBarButton
    }

    func hideLoading() {
        self.stopAnimating()
    }

    func showLoadingOnParent() {
        let size = CGSize(width: Common.activityIndicatorHeight, height: Common.activityIndicatorHeight)
        startAnimating(size, message: "", messageFont: nil, type: NVActivityIndicatorType(rawValue: 23)!,
                       color: .white, padding: 0, displayTimeThreshold: 0,
                       minimumDisplayTime: 0, backgroundColor: .clear, textColor: .white)
    }

    func backButtonClicked(sender: AnyObject) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
