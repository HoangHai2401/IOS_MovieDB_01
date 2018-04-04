//
//  SideViewTableViewCell.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 4/4/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class SideViewTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func setContentForCell(icon: String, name: String) {
        itemImageView.image = UIImage(named: icon)
        itemLabel.text = name
    }
}
