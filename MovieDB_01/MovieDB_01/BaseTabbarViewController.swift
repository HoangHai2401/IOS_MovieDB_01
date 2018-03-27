//
//  BaseTabbarViewController.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class BaseTabbarViewController: UIViewController
{
    private lazy var m_btn_Sidebar: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: "btn_left")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onSidebarButtonClicked(sender:)))
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.leftBarButtonItem = self.m_btn_Sidebar
    }
    
    
    func onSidebarButtonClicked(sender: AnyObject)
    {
        if let container = self.so_containerViewController
        {
            container.isSideViewControllerPresented = true
        }
    }
    
}
