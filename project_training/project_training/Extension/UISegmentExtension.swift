//
//  UISegment+Extension.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func removeBorder() {
        self.backgroundColor = UIColor.gray
        self.tintColor = .clear
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: .selected)
    }

    func addUnderlineForSelectedSegment() {
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 2.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition,
                                    width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.white
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(1) else {return}
        let underlineXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineXPosition
        })
    }
}
