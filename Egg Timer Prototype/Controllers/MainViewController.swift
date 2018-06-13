//
//  ViewController.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 09/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var selectorScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var eggs = [Egg]()
    
    
    var time = 300
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pauseButton.isEnabled = false
        pauseButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        
        let soft = Egg(type: "Soft Boiled", time: 200, description: "Soft and creamy, let the white bit wobble")
        eggs.append(soft)
        
        let medium = Egg(type: "Medium Boiled", time: 300, description: "Little bit runny in the middle, just perfect")
        eggs.append(medium)
        
        let hard = Egg(type: "Hard Boiled", time: 400, description: "Proper good for sandwiches, none of that green bit though")
        eggs.append(hard)
        
        
        //set up scroll view
        //enabling scroll view
        selectorScrollView.isPagingEnabled = true
        selectorScrollView.contentSize = CGSize(width: selectorScrollView.bounds.width * CGFloat(eggs.count), height: selectorScrollView.bounds.height)
        selectorScrollView.showsHorizontalScrollIndicator = false
        selectorScrollView.delegate = self
        
        pageControl.numberOfPages = eggs.count
        
        loadEggs()
        
    }
    
    func loadEggs(){
        //get at index
        for (index, egg) in eggs.enumerated() {
            if let selectorView = Bundle.main.loadNibNamed("EggSelector", owner: self, options: nil)?.first as? EggSelector {
                
                selectorView.title.text = egg.type
                selectorView.desc.text = egg.description
                selectorView.time.text = egg.timeFormatted()
                selectorView.tag = index
                
                selectorScrollView.addSubview(selectorView)
                selectorView.frame.size.width = selectorScrollView.bounds.width
                selectorView.frame.origin.x = CGFloat(index) * selectorScrollView.bounds.size.width
                
            }
            
        }
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        pauseButton.isEnabled = true
        pauseButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
    
    
    @objc func updateTimer() {
        
        if time < 0 {
            print("Done")
            timerLabel.text = "0:00"
            timer.invalidate()
            return
        
        } else {
        
        let minutes = time / 60
        let seconds = time % 60
        let secondsToDisplay = String(format: "%02d", Int(seconds))
        
        time -= 1 //decrement
        timerLabel.text = "\(minutes):\(secondsToDisplay)"
        
        }
    
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            print("Here")
            runTimer()
            isTimerRunning = true
            startButton.isEnabled = false
            startButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
            
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        //using invalidate and resume
        if resumeTapped == false {
            print("Pause")
            pauseButton.setTitle("Resume", for: .normal)
            timer.invalidate()
            resumeTapped = true
        } else {
            print("Restart")
            pauseButton.setTitle("Pause", for: .normal)
            runTimer()
            self.resumeTapped = false
        }
    }
    
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        time = 300
        timerLabel.text = "5:00"
        isTimerRunning = false
        
        startButton.isEnabled = true
        startButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        pauseButton.isEnabled = false
        pauseButton.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
    }
    

}

extension MainViewController {
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //adjust page control
        let page = selectorScrollView.contentOffset.x / selectorScrollView.frame.size.width
        pageControl.currentPage = Int(page)
        
        //assign time
        let index = Int(page)
        time = eggs[index].time
        timerLabel.text = eggs[index].timeFormatted()
    }
    
}

