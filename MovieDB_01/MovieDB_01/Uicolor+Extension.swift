//
//  Uicolor+Extension.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/28/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import UIKit

public extension UIColor
{
    public class func hexColor(hex: Int, alpha: Double) -> UIColor
    {
        return UIColor.init(red: CGFloat(Double(((hex&0xff0000)>>16))/255.0),
                            green: CGFloat(Double(((hex&0x0ff00)>>8))/255.0),
                            blue: CGFloat(Double((hex&0x0ff))/255.0),
                            alpha: CGFloat(alpha))
    }
    
    public class func rgbColor(red: Double, green: Double, blue: Double, alpha: Double) -> UIColor
    {
        return UIColor.init(red: CGFloat(red/255.0),
                            green: CGFloat(green/255.0),
                            blue: CGFloat(blue/255.0),
                            alpha: CGFloat(alpha))
    }
}
