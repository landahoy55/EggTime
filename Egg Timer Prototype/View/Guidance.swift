//
//  Guidance.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 17/08/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

public class Guidance: UIView  {
    
//    @IBOutlet weak var imageView: UIImageView!
 
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("Guidance", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 25
        gradientView.gradientLayer(topColor: #colorLiteral(red: 0.9359737039, green: 0.5379887223, blue: 1, alpha: 1), bottomColor: #colorLiteral(red: 0.7921568627, green: 0.9450980392, blue: 0.9411764706, alpha: 1))
    }
    
    //maybe animate?
    
//    public func useGradient() {
//         self.contentView.backgroundColor = .clear
//        self.backgroundColor = .clear
//        self.gradientLayer(topColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), bottomColor: #colorLiteral(red: 0.05900000036, green: 0.7099999785, blue: 0.6940000057, alpha: 1))
//    }
//
//    public func useFlat() {
//
//        self.contentView.backgroundColor = .clear
//        self.backgroundColor = .clear
//        self.backgroundColor = #colorLiteral(red: 0.05900000036, green: 0.7099999785, blue: 0.6940000057, alpha: 1)
//
//    }

}
