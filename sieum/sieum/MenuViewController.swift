//
//  MenuViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import PopupDialog

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
        
//        self.presentShareAlert()
        
        NotificationCenter.default.post(name: Constants.observer.requestShare, object: nil)
    }
    
    func presentShareAlert(){
        // Customize dialog appearance
        let pv = PopupDialogDefaultView.appearance()
        pv.titleFont    = UIFont(name: "IropkeBatangOTFM", size: 16)!
        pv.titleColor   = UIColor.white
        pv.messageFont  = UIFont(name: "IropkeBatangOTFM", size: 14)!
        pv.messageColor = UIColor(white: 0.8, alpha: 1)
        
        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
//        pcv.backgroundColor = UIColor(red:0.23, green:0.23, blue:0.27, alpha:1.00)
        pcv.backgroundColor = UIColor.alertBackground()
        pcv.cornerRadius    = 2
        pcv.shadowEnabled   = true
        pcv.shadowColor     = UIColor.black
        
        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled = true
        ov.blurRadius  = 30
        ov.liveBlur    = true
        ov.opacity     = 0.7
        ov.color       = UIColor.black
        
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

        
        // Prepare the popup assets
        let title = "THIS IS THE DIALOG TITLE"
        let message = "This is the message section of the popup dialog default view"
        let image = UIImage(named: "pexels-photo-103290")
        
    
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, buttonAlignment: .horizontal, transitionStyle: .fadeIn, gestureDismissal: true) {
            
        }
        
        // Create buttons
        let buttonOne = CancelButton(title: "취소") {
            print("You canceled the car dialog.")
        }
        
        let buttonTwo = DefaultButton(title: "ADMIRE CAR") {
            print("What a beauty!")
        }
        
        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
            print("Ah, maybe next time :)")
        }
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
//        popup.addButtons([buttonOne, buttonTwo, buttonThree])
//        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        popup.addButton(buttonOne)
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
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
