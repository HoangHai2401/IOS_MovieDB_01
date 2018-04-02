//
//  ViewController.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/1/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData() {
        ApiService.apiService.apiRequest(api: Urls.nowPlayingUrl, page: 1) { (json) in
            print(json)
        }
    }
}
