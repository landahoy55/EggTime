//
//  Eggs.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 16/08/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

class Data {
    
    static var eggModels = [Egg]()
    
    static func createEggs() -> [Egg]{
        
        eggModels.append(Egg(type: "Runny Yolk", time: 1, description: "Perfect for dipping, get the toast on", colour: #colorLiteral(red: 0.9058823529, green: 0.3882352941, blue: 0, alpha: 1)))
        
        eggModels.append(Egg(type: "Liquid Yolk", time: 360, description: "Plop on some steaming ramen", colour: #colorLiteral(red: 0.9058823529, green: 0.4649497038, blue: 0, alpha: 1)))
        
        eggModels.append(Egg(type: "Almost Set", time: 420, description: "Just the thing for salads", colour: #colorLiteral(red: 0.9058823529, green: 0.5452719694, blue: 0, alpha: 1)))
        
        eggModels.append(Egg(type: "Softly Set", time: 480, description: "Perfect for scotch eggs, or in a curry", colour: #colorLiteral(red: 0.9058823529, green: 0.6165339052, blue: 0, alpha: 1)))
        
        eggModels.append(Egg(type: "Hard Boiled", time: 540, description: "Classic - sandwich material", colour: #colorLiteral(red: 0.9058823529, green: 0.6785727507, blue: 0, alpha: 1)))
        
        return eggModels
    }
    
}
