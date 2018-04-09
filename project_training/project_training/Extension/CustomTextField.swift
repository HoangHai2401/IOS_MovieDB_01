//
//  CustomTextField.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/8/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomTextField: UITextField {

    @IBInspectable
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var imageView: UIImageView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.borderStyle = .none
        setupImageView()
    }

    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    func setupImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.leftView = imageView
        self.leftViewMode = .always
    }
}
