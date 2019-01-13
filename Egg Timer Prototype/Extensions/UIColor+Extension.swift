//
//  UIColor+Extension.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 22/08/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     Create a ligher color
     */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    /**
     Try to increase brightness or decrease saturation
     */
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
}
