//
//  Egg.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 13/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

struct Egg {
    
    var type: String
    var time: Int
    var description: String
    var colour: UIColor
    
    func timeFormatted() -> String {
        
        let minutes = time / 60
        let seconds = time % 60
        let secondsToDisplay = String(format: "%02d", Int(seconds))
        
        return "\(minutes):\(secondsToDisplay)"
        
    }
    
}
