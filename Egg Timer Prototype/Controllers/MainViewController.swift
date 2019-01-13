//
//  ViewController.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 09/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SwipeUpView

//TODO: - Break into seperate file
private enum MenuState {
    case closed
    case open
}

extension MenuState {
    var opposite: MenuState {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

private enum ActivityState {
    case waiting
    case running
    case paused
    case restarted
}


class MainViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var selectorScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var eggTypeLabel: UILabel!
    
    @IBOutlet weak var pulseview: UIView!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    let selectionGenerator = UISelectionFeedbackGenerator()
    
    var eggs = [Egg]()
    
    var originalTime = 5 //300
    var time = 5 //300
    var timer = Timer() 

    
    //Default is
    var chosenEgg: Egg!
    
    //swipe up views in code...
    //notice how zero frame is being use.
    lazy var bottomView : Guidance = {
        return Guidance(frame:.zero)
    }()
    
    lazy var swipeUpView : SwipeUpView = {
        let view = SwipeUpView(frame: .zero, mainView: self.view)
        view.delegate = self
        view.datasource = self
        
        view.swipeContentView = bottomView
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeUpView.openViewPage()
        
        //refactor
        let image : UIImage = UIImage(named: "tiny-logo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 23))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        
     
        eggs = Data.createEggs()
        chosenEgg = eggs[0]
        originalTime = eggs[0].time
        time = eggs[0].time
        
        eggTypeLabel.alpha = 0
        pageControl.numberOfPages = eggs.count
    
        setUpScrollView()
        loadEggSelectionView()
        pulseview.pulse()
        
        changeStartButtonColour(to: chosenEgg.colour)
        
        
        
        //promptView.addGestureRecognizer(tapRecognizer)
        
        //set up observers
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground(notification:)), name: .UIApplicationDidEnterBackground, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground(notification:)),       name: .UIApplicationWillEnterForeground, object: nil)
        
        swipeUpView.layoutIfNeeded()
        swipeUpView.layer.masksToBounds = true
        swipeUpView.layer.cornerRadius = 20
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setUpScrollView() {
        selectorScrollView.isPagingEnabled = true
        selectorScrollView.contentSize = CGSize(width: selectorScrollView.bounds.width * CGFloat(eggs.count), height: selectorScrollView.bounds.height)
        selectorScrollView.showsHorizontalScrollIndicator = false
        selectorScrollView.delegate = self
    }
    
    private func loadEggSelectionView(){
        //get at index
        for (index, egg) in eggs.enumerated() {
            
            //get selectpr view
            if let selectorView = Bundle.main.loadNibNamed("EggSelector", owner: self, options: nil)?.first as? EggSelector {
                
                //set up
                selectorView.title.text = egg.type
                selectorView.desc.text = egg.description
           
                selectorView.tag = index
                
                //add to subview (adding to the right)
                selectorScrollView.addSubview(selectorView)
                selectorView.frame.size.width = selectorScrollView.bounds.width
                selectorView.frame.origin.x = CGFloat(index) * selectorScrollView.bounds.size.width
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        pageControl.customPageControl(dotFillColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), dotBorderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), dotBorderWidth: 0.5)
        
        progressRing.ringStyle = .gradient
        
        progressRing.innerCapStyle = .square
        progressRing.outerCapStyle = .square
        progressRing.alpha = 0.3
    }
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer() {
        
        if time < 0 {
            selectorScrollView.isScrollEnabled = true
            print("Done")
            
            UIView.animate(withDuration: 0.3) {
                self.progressRing.value = 0
                self.eggTypeLabel.alpha = 0
                self.pageControl.alpha = 1
            }
            
            //invalidate timer
            masterReset()
            
            performSegue(withIdentifier: "doneSegue", sender: self)
            
            selectorScrollView.isScrollEnabled = true
            startButton.isEnabled = true
            startButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            startButton.setTitle("Start", for: .normal)
            
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
    
    private var activityState: ActivityState = .waiting
    
    
    //MARK:- Observer functions
    @objc func enterBackground(notification: Notification) {
        print("Entered background")
        
        //invalidate timer
        timer.invalidate()
        
        
        //if not running exit.
        if activityState == .waiting {
            return
        }
        
        
        UserDefaults.standard.set(Date(), forKey: "savedTime")
        UserDefaults.standard.set(time, forKey: "timeRemaining")
        print(Date())
       
        
    }
    
    
    //TODO starting when returning from background...
    
    @objc func enterForeground(notification: Notification) {
        print("Back in the foreground")
        print("activity state", activityState)
        
        
        if activityState != .waiting {
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
        

    }
    
    //TODO: Consider restart?
    //4 states
        // - Not Started (waiting to start)
        // - Running (from inital)
        // - Paused
        // - Restarted from pause - restart is not different? Possibly will affect notfications?
    

    @IBAction func startButtonTapped(_ sender: UIButton) {

        switch activityState {
            
            case .waiting:
                
                    feedbackGenerator.notificationOccurred(.success)
                    activityState = .running
                    runTimer()
                    selectorScrollView.isScrollEnabled = false
                    
                    setButtonandPulse(buttonText: "Pause", pulseStatus: true)
                    setNotification(time: time)
                    
                    UIView.animate(withDuration: 0.3) {
                        self.eggTypeLabel.alpha = 1
                        self.pageControl.alpha = 0.3
                    }
            
            case .running:
                
                //switch to pause.
                print("WE ARE RUNNING")
                selectionGenerator.selectionChanged()
                
                activityState = .paused
                timer.invalidate()

                setButtonandPulse(buttonText: "Resume", pulseStatus: false)
                
                UNService.shared.removeRequest()
                
                UIView.animate(withDuration: 0.3) {
                    self.startButton.setTitleColor(.white, for: .normal)
                    self.changeStartButtonColour(to: Colours.blue)
                }
            
            case .paused:
                
                //switch to running
                
                feedbackGenerator.notificationOccurred(.success)
                
                activityState = .running
                runTimer()
                
                setButtonandPulse(buttonText: "Pause", pulseStatus: true)
                setNotification(time: time)
                
                UIView.animate(withDuration: 0.3) {
                    self.startButton.setTitleColor(.black, for: .normal)
                    self.changeStartButtonColour(to: self.chosenEgg.colour)
                }

            case .restarted:
                return
        }
    }
    
    internal func masterReset() {
       //cancel notification
       UNService.shared.removeRequest()
       
       //cancel user defaults
        UserDefaults.standard.removeObject(forKey: "savedTime")
        UserDefaults.standard.removeObject(forKey: "timeRemaining")
        UserDefaults.standard.synchronize()
        
        
       //reset timers
       timer.invalidate()
       originalTime = chosenEgg.time
       time = chosenEgg.time
       timerLabel.text = chosenEgg.timeFormatted()
        
        
       selectorScrollView.isScrollEnabled = true
       startButton.isEnabled = true
       startButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
       startButton.setTitle("Start", for: .normal)
       startButton.setTitleColor(chosenEgg.colour, for: .normal)
       activityState = .waiting
        
       pulseview.pulse()
        
    }
    
    private func setNotification(time: Int) {
        UNService.shared.authorise()
        UNService.shared.timerRequest(with: TimeInterval(time))
    }
    
    private func setButtonandPulse(buttonText text: String, pulseStatus status: Bool) {
        startButton.setTitle(text, for: .normal)
        pulseview.isHidden = status
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "settingsSegue":
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.customTimeDelegate = self
        case "doneSegue":
            let doneVC = segue.destination as! DoneViewController
            doneVC.eggDoneDelegate = self
        default:
            return
        }
    }
    
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        print("Reset tapped")
        
        feedbackGenerator.notificationOccurred(.warning)
        
        UIView.animate(withDuration: 0.3) {
            self.progressRing.value = 0
            self.eggTypeLabel.alpha = 0
            self.pageControl.alpha = 1
        }
        
        masterReset()
    }

//unwind segue
    @IBAction func unwindToMainVC(segue:UIStoryboardSegue) { }

    func changeStartButtonColour(to newColour: UIColor) {
        startButton.backgroundColor = newColour
        pulseview.backgroundColor = newColour

        progressRing.innerRingColor = newColour
    }

    var index  = 0
    
}

extension MainViewController {

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        selectionGenerator.selectionChanged()
        
        //adjust page control
        let page = selectorScrollView.contentOffset.x / selectorScrollView.frame.size.width
        
        index = Int(page)
        pageControl.currentPage = Int(index)
        
        //choose egg...
        chosenEgg = eggs[index]
        
        pageControl.customPageControl(dotFillColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), dotBorderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), dotBorderWidth: 0.5)
        
        //TODO: Why two timer vars? Is one running and one just a placeholder?
        originalTime = chosenEgg.time
        time = chosenEgg.time
        
        UIView.animate(withDuration: 0.3) {
            print("In animation block")
            
            self.timerLabel.text = self.chosenEgg.timeFormatted()
            self.eggTypeLabel.text = self.chosenEgg.type.components(separatedBy: " ").first
            
            self.changeStartButtonColour(to: self.chosenEgg.colour)
    
        }
        
    }
    
}

extension MainViewController: SwipeUpViewDatasource {
    
    func firstOpenHeightIndex(_ swipeUpView: SwipeUpView) -> Int {
        return 0
    }
    
    func heights(_ swipeUpView: SwipeUpView) -> [CGFloat] {
        return []
    }
    
    func heightPercentages(_ swipeUpView: SwipeUpView) -> [CGFloat] {
        return [0.07, 0.7]
    }
    
    func hideHeaderButton(_ swipeUpView: SwipeUpView) -> Bool {
        return true
    }
    
    func heightOfHeaderButton(_ swipeUpView: SwipeUpView) -> CGFloat {
        return  5.0
    }
    
    func widthOfHeaderButton(_ swipeUpView: SwipeUpView) -> CGFloat {
        return 50.0
    }
    
    func colorOfHeaderButton(_ swipeUpView: SwipeUpView) -> UIColor {
        return .black
    }
    
    func marginOfHeaderButton(_ swipeUpView: SwipeUpView) -> CGFloat {
        return 5
    }
    
    
}

extension MainViewController: SwipeUpViewDelegate {
    func swipeUpViewStateWillChange(_ swipeUpView: SwipeUpView, stateIndex: Int) {
        print("State will change", stateIndex)
    }
    
    func swipeUpViewStateDidChange(_ swipeUpView: SwipeUpView, stateIndex: Int) {
        print("State did change", stateIndex)
    }
    
    func swipeUpViewWillOpen(_ swipeUpView: SwipeUpView) {
        print("Swipe up will open")
    }
    
    func swipeUpViewDidOpen(_ swipeUpView: SwipeUpView) {
        print("Swipe up did open")
    }
    
    func swipeUpViewWillClose(_ swipeUpView: SwipeUpView) {
        print("Swipe up will close")
    }
    
    func swipeUpViewDidClose(_ swipeUpView: SwipeUpView) {
        print("Swipe up did close")
    }
    
    
}

extension MainViewController: DoneDelegate {
    
    func reset() {
        print("Delegate triggered")
        
        masterReset()
        startButton.setTitleColor(.black, for: .normal)
    }
}

extension MainViewController: SettingsDelegate {
    
    func customTime(toSet length: Int) {
        print("DELEGATE FIRED OFF", length)
    }
    
}



