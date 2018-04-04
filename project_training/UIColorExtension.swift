//
//  UIColor+Extension.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    static var navigationColor: UIColor {
        return UIColor.gray
    }

    public class func rgbColor(red: Int, green: Int, blue: Int, alpha: Double = 1) -> UIColor {
        return UIColor.init(red: CGFloat(red) / 255.0,
                            green: CGFloat(green) / 255.0,
                            blue: CGFloat(blue) / 255.0,
                            alpha: CGFloat(alpha))
    }
}
