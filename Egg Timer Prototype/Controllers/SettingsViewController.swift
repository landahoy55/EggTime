//
//  SettingsViewController.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 01/07/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit


//delegate for custom time
protocol SettingsDelegate {
    func customTime(toSet length: Int)
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    let pickerInputData = [
        ["0","1","2","3","4","5","6","7","8","9","10"],
        ["00","01","02","03","04","05","06","07","08","09","10",
         "11","12","13","14","15","16","17","18","19","20",
         "21","22","23","24","25","26","27","28","29","30",
         "31","32","33","34","35","36","37","38","39","40",
         "41","42","43","44","45","46","47","48","49","50",
         "51","52","53","54","55","56","57","58","59","60",
         ]
    ]
    
    //time vars
    var minutes = 0
    var seconds = 0
    
    //delegate
    var customTimeDelegate: SettingsDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
    
        customTimeDelegate.customTime(toSet: 5)
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
        
    }
    
}

//Picker delegate methods
extension SettingsViewController {
    
    //number of components - in our case three.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerInputData.count
    }
    
    //Read number of rows from picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerInputData[component].count
    }
    
    //Read multi-dimensional array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerInputData[component][row]
    }
    
    //did select
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        print(component)
        
        switch component {
        case 0:
            minutes = Int(pickerInputData[component][row])!
            print("Minutes", minutes)
        case 1:
            seconds = Int(pickerInputData[component][row])!
            print("Seconds", seconds)
    
        default:
            break
        }
    }
    

}
