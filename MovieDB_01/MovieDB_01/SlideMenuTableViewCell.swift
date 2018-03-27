//
//  SlideMenuTableViewCell.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

class SlideMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name_item: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
