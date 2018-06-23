//
//  AppDelegate.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 6..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import SwiftyBeaver
import FBSDKCoreKit
import PopupDialog
import UserNotifications

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationDelegate = UYLNotificationDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.setLogger()
        self.setAlertView()
        self.setNotiDelegate()
        
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests(completionHandler: { (requestList) in
            
            if(requestList.count > 0){
                
                self.setNotiAuth()
                
            }
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK:- Logger
    
    func setLogger(){
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
//        let file = FileDestination()  // log to default swiftybeaver.log file
//        let cloud = SBPlatformDestination(appID: "foo", appSecret: "bar", encryptionKey: "123") // to cloud
        
        // use custom format and set console output to short time, log level & message
        //        console.format = "$DHH:mm:ss$d $L $M"
        
        if("$L" == "VERBOSE"){
            console.format = "$DHH:mm:ss$d 💜 $L $M"
        }else if("$L" == "DEBUG"){
            console.format = "$DHH:mm:ss$d 💚 $L $M"
        }else if("$L" == "INFO"){
            console.format = "$DHH:mm:ss$d 💙 $L $M"
        }else if("$L" == "WARNING"){
            console.format = "$DHH:mm:ss$d 💛 $L $M"
        }else if("$L" == "ERROR"){
            console.format = "$DHH:mm:ss$d ❤️ $L $M"
        }
        
        // or use this for JSON output: console.format = "$J"
        
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
//        log.addDestination(file)
//        log.addDestination(cloud)
    }
    
    // MARK :- Facebook
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }

    
    // MARK :- Alert Appearance
    func setAlertView(){
        
        // Customize dialog appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "IropkeBatangOTFM", size: 16)!
        pv.titleColor   = UIColor.white
        pv.messageFont  = UIFont(name: "IropkeBatangOTFM", size: 14)!
        pv.messageColor = UIColor(white: 0.8, alpha: 1)
        //        pv.sizeThatFits(CGSize.init(width: screenWidth/2, height: pv.bounds.height))
        
        
        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = UIColor.alertBackground()
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        //pcv.shadowColor     = UIColor.black
        
        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled = false
        ov.blurRadius  = 30
        ov.liveBlur    = false
        ov.opacity     = 0.0
        ov.color       = UIColor.clear
        
        // Customize default button appearance
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "IropkeBatangOTFM", size: 14)!
        db.titleColor     = UIColor.white
        db.buttonColor    = UIColor.alertBackground()
        db.separatorColor = UIColor.defaultBackground()
        
        // Customize cancel button appearance
        let cb = CancelButton.appearance()
        cb.titleFont      = UIFont(name: "IropkeBatangOTFM", size: 14)!
        cb.titleColor     = UIColor(white: 0.6, alpha: 1)
        cb.buttonColor    = UIColor.alertBackground()
        cb.separatorColor = UIColor.defaultBackground()
        
    }
    
    
    // MARK :- Noti
    func setNotiDelegate(){
        
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationDelegate
    }
    
    
    
    
    
//    func setNotiAuth(){
//        
//        let center = UNUserNotificationCenter.current()
//        let options: UNAuthorizationOptions = [.alert, .sound]
//        
//        center.requestAuthorization(options: options) { (granted, error) in
//            
//            if !granted {
//                print("Something went wrong")
//            }
//
//        }
//        
//    }
    
    
    // MARK :- Noti
    func setNotiAuth(){
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { (settings) in
            
            if settings.authorizationStatus != .authorized {
                
                // Notifications not allowed
                
                let options: UNAuthorizationOptions = [.alert, .sound]
                center.requestAuthorization(options: options) { (granted, error) in
                    
                    if !granted {
                        print("인증되지 않았습니다")
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
    }

}

