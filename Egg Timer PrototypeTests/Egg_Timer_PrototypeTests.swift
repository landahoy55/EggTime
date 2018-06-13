//
//  Egg_Timer_PrototypeTests.swift
//  Egg Timer PrototypeTests
//
//  Created by P Malone on 09/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import XCTest
@testable import Egg_Timer_Prototype

class Egg_Timer_PrototypeTests: XCTestCase {
    
    //check title
    func test_title_is_good_egg(){
        //call vc
        let vc = viewControllerSetUp()
        XCTAssertEqual(vc.navigationItem.title, "Good Egg")
    }
    
    //check timer label exists
    func test_timer_label_shows_five_minutes(){
        let vc = viewControllerSetUp()
        XCTAssertEqual(vc.timerLabel.text, "5:00")
    }
    
    //check timer works
    func test_start_timer(){
        let vc = viewControllerSetUp()
        vc.runTimer()
        XCTAssertTrue(vc.pauseButton.isEnabled)
    }
    
    //check start button works
    func test_startButton(){
        let vc = viewControllerSetUp()
        vc.startButtonTapped(vc.startButton)
        XCTAssertTrue(vc.isTimerRunning)
    }
    
    //press button twice. check for true then false
    func test_pauseButton(){
        let vc = viewControllerSetUp()
        vc.pauseButtonTapped(vc.pauseButton)
        XCTAssertTrue(vc.resumeTapped)
        vc.pauseButtonTapped(vc.pauseButton)
        XCTAssertFalse(vc.resumeTapped)
    }
    
    //check timer value changes when quick changes are made
    func test_time_changes(){
        let vc = viewControllerSetUp()
        vc.changeTimer(vc.softButton)
        XCTAssertEqual(vc.time, 200)
        vc.changeTimer(vc.mediumButton)
        XCTAssertEqual(vc.time, 300)
        vc.changeTimer(vc.hardButton)
        XCTAssertEqual(vc.time, 400)
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //check reset
    
    //setup
    func viewControllerSetUp() -> MainViewController {
        //create settings vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main Screen") as! MainViewController
        
        //call required to make ibOutlets etc work
        let _ = vc.view
        
        return vc
    }
    
}
