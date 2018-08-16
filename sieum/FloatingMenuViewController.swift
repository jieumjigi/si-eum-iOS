//
//  FloatingMenuViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import PopupDialog
import UserNotifications

class FloatingMenuViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        log.verbose("menu viewDidAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onShareButton(_ sender: Any) {
        let eventName = "onShareButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)
      
        NotificationCenter.default.post(name: GlobalConstants.observer.requestShare, object: nil)
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
        let popup = PopupDialog(title: title, message: message, image: image, buttonAlignment: .horizontal, transitionStyle: .fadeIn) {
            
        }
        
        // Create buttons
        let buttonOne = CancelButton(title: "취소") {
            print("You canceled the car dialog.")
        }
        
        popup.addButton(buttonOne)
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    
    func presentTimerAlert(){
        
        let myDatePicker: UIDatePicker = UIDatePicker()
        
        // setting properties of the datePicker
        myDatePicker.datePickerMode = UIDatePickerMode.time
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect.init(x: 0, y: 30, width: 270, height: 150)
        let alertController = UIAlertController(title: "" , message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        alertController.view.addSubview(myDatePicker)
        alertController.view.tintColor = UIColor.alertBackground()
        
        
        let confirmAction = UIAlertAction.init(title: "확인", style: .default) { (action) in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            let selectedHour = Int(dateFormatter.string(from: myDatePicker.date))
            
            dateFormatter.dateFormat = "mm"
            let selectedMinute = Int(dateFormatter.string(from: myDatePicker.date))
            
            print("selectedHours : \(String(describing: selectedHour))")
            print("selectedHours : \(String(describing: selectedMinute))")
            
            
            
            // 반복되는 노티 만들기
            
            var dateComponents = DateComponents()
            dateComponents.hour = selectedHour
            dateComponents.minute = selectedMinute
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: true)

            let content = UNMutableNotificationContent()
            content.body = "오늘의 시가 도착했습니다"
            content.sound = UNNotificationSound.default()
            
            
            // 설정
            let center = UNUserNotificationCenter.current()
            
            let request = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)

            center.removeAllPendingNotificationRequests()
            center.add(request, withCompletionHandler: { (error) in

                
            })
            
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion:{})
        
    }
    
    func presentTimerSwitchAlert(){
        
        // Prepare the popup assets
        let title = "알림을 설정하겠습니까?"
        let message = "시간을 정해두고 매일 시를 만나보세요"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn) {
            
        }
        
        // Create buttons
        let confirmButton = DefaultButton(title: "확인") {
            self.setNotiAuth()
            self.presentTimerAlert()
        }
        
        let cancelButton = CancelButton(title: "취소") {
            
        }
        
        popup.addButton(cancelButton)
        popup.addButton(confirmButton)

        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    
    
    func presentEditTimerAlert(){
        
        self.setNotiAuth()
        
        // Prepare the popup assets
        let title = "이미 설정된 알림이 있습니다"
        let message = "삭제하거나 변경하겠습니까?"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn) {
            
        }
        
        // Create buttons
        let confirmButton = DefaultButton(title: "변경") {
            
            self.presentTimerAlert()
            
        }
        
        let cancelButton = CancelButton(title: "삭제") {
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            
        }
        
        popup.addButton(cancelButton)
        popup.addButton(confirmButton)
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
    }
    
    
    @IBAction func onSaveButton(_ sender: Any) {
        let eventName = "onSaveButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)
        
        NotificationCenter.default.post(name: GlobalConstants.observer.requestSave, object: nil)
    }
    
    @IBAction func onTimerButton(_ sender: Any) {
        let eventName = "onTimerButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)
        
//        NotificationCenter.default.post(name: Constants.observer.requestTimer, object: nil)
        
//        if(){ // 이미 설정한 알림이 있는 경우
//            self.presentEditTimerAlert()
//        }else{
//            self.presentTimerSwitchAlert()
//        }
        
        self.checkExistNoti()
        
    }
    
    @IBAction func onInfoButton(_ sender: Any) {
        
        let eventName = "onInfoButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)
        
        let infoViewController = self.storyboard!.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        let navController = UINavigationController(rootViewController: infoViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
        
    }
    
    
    @IBAction func onMenuPopButton(_ sender: Any) {
        
        let eventName = "onMenuPopButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)
        NotificationCenter.default.post(name: GlobalConstants.observer.requestMenuPop, object: nil)
        
    }
    
    
    
    
    
    
//    // MARK: - Observer
//    
//    func handleMenuOpen(){
//        
//        UIView.animate(withDuration: 0.7) {
//            
//            self.openButton.alpha = 0.0
//            
//        }
//        
//    }
//    
//    func handleMenuClose(){
//        
//        UIView.animate(withDuration: 0.7) {
//            
//            self.openButton.alpha = 1.0
//
//            
//        }
//        
//    }
//    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
    
    func checkExistNoti(){
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notiRequestList) in
            
            if(notiRequestList.count > 0){
                self.presentEditTimerAlert()

            }else{
                self.presentTimerSwitchAlert()
            }
            
        }
    }
}
