//
//  CustomSideViewController.swift.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class CustomSideViewController: UIViewController {
    @IBOutlet weak var sideTableView: UITableView!

    let items = ["Favorite Movies", "Infor app", "Feed back"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setSideTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setSideTableView() {
        sideTableView.delegate = self
        sideTableView.dataSource = self
    }
}

// MARK: extension UITableViewDelegate for sideTableView
extension CustomSideViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "favorite", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "info", sender: nil)
        default:
            print("feed back")
        }
    }
}

// MARK: extension UITableViewDataSource for sideTableView
extension CustomSideViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? SideViewTableViewCell else {
                                                        let cell = tableView.dequeueReusableCell(
                                                            withIdentifier: "cell", for: indexPath)
                                                        return cell
        }
        switch indexPath.row {
        case 0:
            cell.setContentForCell(icon: "favorite", name: items[0])
        case 1:
            cell.setContentForCell(icon: "info", name: items[1])
        default:
            cell.setContentForCell(icon: "letter", name: items[2])
        }
        return cell
    }
}
