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
        
        eggModels.append(Egg(type: "Runny Yolk", time: 300, description: "Perfect for dipping, get the toast on", colour: #colorLiteral(red: 0.9058823529, green: 0.4588235294, blue: 0.1215686275, alpha: 1)))
        
        eggModels.append(Egg(type: "Liquid Yolk", time: 360, description: "Plop on some steaming ramen", colour: #colorLiteral(red: 0.9411764706, green: 0.5647058824, blue: 0.1411764706, alpha: 1)))
        
        eggModels.append(Egg(type: "Almost Set", time: 420, description: "Just te thing for salads", colour: #colorLiteral(red: 0.9647058824, green: 0.6745098039, blue: 0.1607843137, alpha: 1)))
        
        eggModels.append(Egg(type: "Softly Set", time: 480, description: "Perfect scortch eggs, or in a curry", colour: #colorLiteral(red: 0.9764705882, green: 0.8666666667, blue: 0.3450980392, alpha: 1)))
        
        eggModels.append(Egg(type: "Hard Boiled", time: 540, description: "Classic - sandwich material", colour: #colorLiteral(red: 0.9764705882, green: 0.8666666667, blue: 0.3450980392, alpha: 1)))
        
        return eggModels
    }
    
}
