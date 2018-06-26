//
//  UIView+Extension.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 19/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

extension UIView {
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        
        shake.duration = 0.3
        //shake.repeatCount = 40
        shake.autoreverses = true
        shake.repeatDuration = 6
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y - 5)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y + 5)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: nil)
    }

    
    func rotate(){
        print("rotate")
        let rotate = CABasicAnimation()
        rotate.fromValue = -0.1
        rotate.toValue = 0.1
        rotate.duration = 0.1
        rotate.autoreverses = true
        rotate.repeatDuration = .infinity
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        layer.add(rotate, forKey: "transform.rotation")
    }
    
}
