//
//  ViewController.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/1/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit
import SidebarOverlay

class ViewController: SOContainerViewController {
    override var isSideViewControllerPresented: Bool {
        didSet {
            if isSideViewControllerPresented == true {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                to: nil, from: nil, for: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSidebar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupSidebar() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        self.menuSide = .left
        self.menuWidth = 0.7 * width
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideViewController")
    }
}
