//
//  AppDelegate.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 6..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import UserNotifications

import FBSDKCoreKit
import Firebase
import FirebaseUI
import PopupDialog
import RxSwift
import SHSideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationDelegate = UYLNotificationDelegate()
    let disposeBag: DisposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = SideMenuViewController(left: MenuViewController())
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setAlertView()
        setNotiDelegate()
        
        UNUserNotificationCenter.current()
            .getPendingNotificationRequests(completionHandler: { [weak self] requestList in
                guard requestList.count > 0 else {
                    return
                }
                self?.setNotiAuth()
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
    
    // MARK: - Facebook
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String else {
            return false
        }
        
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }

        return false
    }
    
    // MARK: - Alert Appearance
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
    
    // MARK: - Noti
    func setNotiDelegate(){
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationDelegate
    }

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

