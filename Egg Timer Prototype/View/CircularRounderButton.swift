//
//  CircularRounderButton.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 09/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit
class CircularRoundedButton: RoundedButton {
    
    override func setUp() {
        super.setUp()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
}
