//
//  AppDelegate.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 6..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import SwiftyBeaver
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setLogger()
        
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

}

