//
//  UIImageView+Extension.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "frame.png"))
        self.contentMode = .scaleAspectFit
    }
}
