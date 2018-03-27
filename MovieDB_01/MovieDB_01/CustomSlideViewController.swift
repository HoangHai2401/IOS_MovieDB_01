//
//  CustomSlideViewController.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class CustomSlideViewController: UIViewController {
    @IBOutlet weak var tb_slide_view: UITableView!
    let item = ["Favorite Movies", "Infor app", "Feed back"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tb_slide_view.delegate=self
        tb_slide_view.dataSource=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension CustomSlideViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SlideMenuTableViewCell
        if indexPath.row == 0 {
            cell.name_item.text = item[0]
            cell.icon.image=UIImage(named: "home")
        }
        if indexPath.row == 1 {
            cell.name_item.text = item[1]
            cell.icon.image=UIImage(named: "home")
        }
        if indexPath.row == 2 {
            cell.name_item.text = item[2]
            cell.icon.image=UIImage(named: "home")
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
