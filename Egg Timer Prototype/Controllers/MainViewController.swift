//
//  ViewController.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 09/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit
import UICircularProgressRing

class MainViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var selectorScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var eggTypeLabel: UILabel!
    
    @IBOutlet weak var pulseview: UIView!
    @IBOutlet weak var progressRing: UICircularProgressRingView!
    
    var eggs = [Egg]()
    
    var originalTime = 5
    var time = 5
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        
        
        
        eggTypeLabel.alpha = 0
        
        //set up page view
        pageControl.numberOfPages = eggs.count
    
        loadEggSelectionView()
        animatePulseView()
        changeStartButtonColour(to: Colours.lightYellow)
        
        //set up observers
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground(notification:)), name: .UIApplicationDidEnterBackground, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground(notification:)),       name: .UIApplicationWillEnterForeground, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        pageControl.customPageControl(dotFillColor: .black, dotBorderColor: .black, dotBorderWidth: 0.5)
        
        progressRing.ringStyle = .gradient
       
        progressRing.innerCapStyle = .square
        progressRing.outerCapStyle = .square
        progressRing.alpha = 0.3
    }
    
    
    func loadEggSelectionView(){
        //get at index
        for (index, egg) in eggs.enumerated() {
            
            //get selectpr view
            if let selectorView = Bundle.main.loadNibNamed("EggSelector", owner: self, options: nil)?.first as? EggSelector {
                
                //set up
                selectorView.title.text = egg.type
                selectorView.desc.text = egg.description
                selectorView.time.text = egg.timeFormatted()
                selectorView.tag = index
                
                //add to subview (adding to the right)
                selectorScrollView.addSubview(selectorView)
                selectorView.frame.size.width = selectorScrollView.bounds.width
                selectorView.frame.origin.x = CGFloat(index) * selectorScrollView.bounds.size.width
                
            }
        }
    }
    
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer() {
        
        if time < 0 {
            selectorScrollView.isScrollEnabled = true
            print("Done")
            isTimerRunning = false
            timerLabel.text = "3:20"
            timer.invalidate()
            startButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            startButton.setTitle("Start", for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                self.progressRing.value = 0
                self.eggTypeLabel.alpha = 0
                self.pageControl.alpha = 1
            }
            
            performSegue(withIdentifier: "doneSegue", sender: self)
            
            return
        
        } else {
            
            print("updating timer")
            
            let minutes = time / 60
            let seconds = time % 60
            let secondsToDisplay = String(format: "%02d", Int(seconds))
            
            time -= 1 //decrement
            print(time)
            timerLabel.text = "\(minutes):\(secondsToDisplay)"
            
            //work out percentage to displ
            let percent: Int = 100 - (Int((Double(time) / Double(originalTime)) * 100))
            print("Percent", percent)
         
            progressRing.animateProperties(duration: 0.3) {
                progressRing.value = CGFloat(percent)
            }

        }
        
    }
    
    
    //MARK:- Observer functions
    @objc func enterBackground(notification: Notification) {
        print("Entered background")
        
        //invalidate timer
        timer.invalidate()
        
        //save current date to user defaults
        UserDefaults.standard.set(Date(), forKey: "savedTime")
        UserDefaults.standard.set(time, forKey: "timeRemaining")
        print(Date())
        
    }
    
    @objc func enterForeground(notification: Notification) {
        print("Back in the foreground")
        
        guard let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date else {
            return
        }
        
        let timeDiff = Date().timeIntervalSince(savedDate)
        
        guard let savedTimer = UserDefaults.standard.object(forKey: "timeRemaining") as? Int else {
            return
        }
        
        let timeRemaining = savedTimer - Int(timeDiff)
 
        //rescheule timer - is there chance to update all labels etc?
        time = timeRemaining
        runTimer()
        
        
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        if isTimerRunning == false {
            
            selectorScrollView.isScrollEnabled = false
            
            print("Timer has started")
            runTimer()
            isTimerRunning = true
            
            startButton.setTitle("Pause", for: .normal)
        
            pulseview.isHidden = true
            
            
            
            UIView.animate(withDuration: 0.3) {
                self.eggTypeLabel.alpha = 1
                self.pageControl.alpha = 0.3
            }
            
            //authorise notifications
            UNService.shared.authorise()
            
            //schedule notification - based on timer
            UNService.shared.timerRequest(with: TimeInterval(time))
            
        } else {
            
            if resumeTapped == false {
                print("Paused")
                
                pulseview.isHidden = false
                
                startButton.setTitle("Resume", for: .normal)
                timer.invalidate()
                resumeTapped = true
                
                //set to button to blue colour
                UIView.animate(withDuration: 0.3) {
                    self.startButton.setTitleColor(.white, for: .normal)
                    self.changeStartButtonColour(to: Colours.blue)
                }
                
            } else {
                print("Restarted")
                startButton.setTitle("Pause", for: .normal)
                runTimer()
                self.resumeTapped = false
                
                //set back to original color
                UIView.animate(withDuration: 0.3) {
                    self.startButton.setTitleColor(.black, for: .normal)
                    
                    switch self.eggTypeLabel.text {
                        case "Soft":
                            self.changeStartButtonColour(to: Colours.lightYellow)
                        case "Medium":
                            self.changeStartButtonColour(to: Colours.mediumYellow)
                        case "Hard":
                            self.changeStartButtonColour(to: Colours.orange)
                        default:
                            self.changeStartButtonColour(to: Colours.blue)
                    }
                    
                }
            }
        }
    }
    
    
    func animatePulseView(){
        
        pulseview.alpha = 1
        pulseview.layer.cornerRadius = self.pulseview.frame.size.width / 2
        
        //can also add in autoreverse.
        //pulsing a view behind the button
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut, .repeat], animations: {
            
            //animate to nothing
            self.pulseview.alpha = 0
            
            //whilst expanding
            self.pulseview.transform = CGAffineTransform(scaleX: 14, y: 14)
        }) { (success) in
//            self.pulseview.transform = CGAffineTransform.identity
        }
    }
    
    func changeStartButtonColour(to newColour: UIColor) {
        startButton.backgroundColor = newColour
        pulseview.backgroundColor = newColour
        progressRing.innerRingColor = newColour
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        print("Reset tapped")
        
        //TODO - base reset on data type
        
        timer.invalidate()
    
        
        originalTime = 200
        time = 200
        timerLabel.text = "3:20"
        isTimerRunning = false
        selectorScrollView.isScrollEnabled = true
        startButton.isEnabled = true
        startButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        startButton.setTitle("Start", for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.progressRing.value = 0
            self.eggTypeLabel.alpha = 0
            self.pageControl.alpha = 1
        }
    }
}

extension MainViewController {

    //method is to twitchy
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("ERR")
        
        //adjust page control
        let page = selectorScrollView.contentOffset.x / selectorScrollView.frame.size.width
        pageControl.currentPage = Int(page)
        
        let index = Int(page)
        
        pageControl.customPageControl(dotFillColor: .black, dotBorderColor: .black, dotBorderWidth: 0.5)
        
        originalTime = eggs[index].time
        time = eggs[index].time
        
        UIView.animate(withDuration: 0.3) {
            print("In animation block")
            
            self.timerLabel.text = self.eggs[index].timeFormatted()
            self.eggTypeLabel.text = self.eggs[index].type.components(separatedBy: " ").first
            
            //TODO - change name
            //change colour of button
            self.indexToAdjust(index: index)
    
        }
        
    }
    
    func indexToAdjust(index: Int) {
        //change colour of start button
        switch index {
        case 0:
            changeStartButtonColour(to: Colours.lightYellow)
        case 1:
            changeStartButtonColour(to: Colours.mediumYellow)
        case 2:
            changeStartButtonColour(to: Colours.orange)
        default:
            changeStartButtonColour(to: Colours.blue)
        }
    }
    
    
}



