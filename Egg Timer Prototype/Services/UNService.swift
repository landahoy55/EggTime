//
//  UNService.swift
//  Egg Timer Prototype
//
//  Created by P Malone on 26/06/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

//NSObject required to delegate to self.
class UNService: NSObject {
    
    //singleton setup
    static let shared = UNService()
    private override init() {
    
    }
    
    let unCenter = UNUserNotificationCenter.current()
    
    //request permissions to send alert
    func authorise() {
    
        //what is required to authorise
        let options: UNAuthorizationOptions = [.alert, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            
            print(error ?? "No UN auth error")
            
            guard granted else {
                //handle when not authorised
                print("User denied access")
                return
            }
            
            //configure when permissions have been granted.
            self.configure()
        }
        
    }
    
    func configure() {
        unCenter.delegate = self
    }
    
    
    func timerRequest(with interval: TimeInterval) {
        
        //notifications require content
        let content = UNMutableNotificationContent()
        content.title = "Eggs ready!"
        content.body = "All done 💪"
        content.sound = .default()
        
        //need to trigger these things!
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        //create request
        let request = UNNotificationRequest(identifier: "userNotification.timer", content: content, trigger: trigger)
        
        //schedule request - can add a completion handler, or additional logic.
        unCenter.add(request)
    }
    
    
    func removeRequest() {
        unCenter.removePendingNotificationRequests(withIdentifiers: ["userNotification.timer"])
    }
}

extension UNService: UNUserNotificationCenterDelegate {
    
    
    //Triggerd when a user responds to a notifcation
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //trigger segue.
        print("UN did recieve response")
        completionHandler()
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //what will happen if app is in foreground... ie, no badge.
        print("UN will present")
     
        let options: UNNotificationPresentationOptions = []
        completionHandler(options)
        
    }
    
}
