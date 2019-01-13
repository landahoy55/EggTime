//
//  UIView+Extension.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 19/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

extension UIView {
    
    func pulse() {
        
        self.alpha = 1
        self.layer.cornerRadius = self.frame.size.width / 2
        
        //can also add in autoreverse.
        //pulsing a view behind the button
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut, .repeat], animations: {
            
            //animate to nothing
            self.alpha = 0
            
            //whilst expanding
            self.transform = CGAffineTransform(scaleX: 14, y: 14)
        }) { (success) in
            //Idenitity = original size.
            //self.pulseview.transform = CGAffineTransform.identity
        }
    }
    
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

    
    func rotate() {
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
    
    func shadowAndCorners() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 30
    }
    
    //set a gradient background view.
    //https://developer.apple.com/documentation/quartzcore/cagradientlayer
    func gradientLayer(topColor:UIColor, bottomColor:UIColor) {
        
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        //add to the top.
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 9.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }



}
