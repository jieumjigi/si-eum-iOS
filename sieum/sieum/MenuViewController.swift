//
//  MenuViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onShareButton(_ sender: Any) {
        let eventName = "onShareButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)

        NotificationCenter.default.post(name: Constants.observer.requestShare, object: nil)
    }
    
    @IBAction func onSaveButton(_ sender: Any) {
        let eventName = "onSaveButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)
        
        NotificationCenter.default.post(name: Constants.observer.requestSave, object: nil)
    }
    
    @IBAction func onTimerButton(_ sender: Any) {
        let eventName = "onTimerButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)
        
        NotificationCenter.default.post(name: Constants.observer.requestTimer, object: nil)

    }
    
    @IBAction func onInfoButton(_ sender: Any) {
        let eventName = "onInfoButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)

        
        let infoViewController = self.storyboard!.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        let navController = UINavigationController(rootViewController: infoViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
    
    }
    
    
    // MARK: - Observer
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
