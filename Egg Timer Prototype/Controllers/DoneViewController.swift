//
//  DoneViewController.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 16/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController {

    @IBOutlet weak var doneImage: UIImageView!
    
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.backgroundColor = Colours.orange
    }
    
    override func viewDidAppear(_ animated: Bool) {

    UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat], animations: {
        self.topView.backgroundColor = Colours.orange
        self.topView.backgroundColor = Colours.blue
    }, completion: nil)
    
    doneImage.rotate()
        
    }

    @IBAction func doneBtn(_ sender: UIButton) {
        print("Here")
        dismiss(animated: true, completion: nil)
    }
    
    
}
