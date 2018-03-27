//
//  MainViewController.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class MainViewController: BaseTabbarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.darkGray

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getdata(){
        Api.httpRequest(api: Common.base_url+""+Common.popular_url+""+Common.api_key){genres in
            if let results: NSArray = genres["results"] as? NSArray{
                print(results)
            }
            
        }
    }

}
