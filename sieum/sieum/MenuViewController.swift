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
import UserNotifications

class MenuViewController: UIViewController {


    
//    @IBOutlet weak var openButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.addObserver()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        log.verbose("menu viewDidAppear")
        
//        UIView.animate(withDuration: 0.5) {
//            self.openButton.alpha = 1.0
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func addObserver(){
//        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.handleMenuOpen),
//            name: Constants.observer.didMenuOpen ,
//            object: nil)
//        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.handleMenuClose),
//            name: Constants.observer.didMenuClose ,
//            object: nil)
//
//        
//    }

    

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
        
//        let buttonTwo = DefaultButton(title: "ADMIRE CAR") {
//            print("What a beauty!")
//        }
//        
//        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
//            print("Ah, maybe next time :)")
//        }
        
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
//        popup.addButtons([buttonOne, buttonTwo, buttonThree])
//        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        popup.addButton(buttonOne)
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    
    func presentTimerAlert(){
        
        let myDatePicker: UIDatePicker = UIDatePicker()
        
        // setting properties of the datePicker
        myDatePicker.datePickerMode = UIDatePickerMode.time
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect.init(x: 0, y: 15, width: 270, height: 150)
        let alertController = UIAlertController(title: "" , message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)

        alertController.view.addSubview(myDatePicker)
        alertController.view.tintColor = UIColor.alertBackground()
        
//        let somethingAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
        let confirmAction = UIAlertAction.init(title: "확인", style: .default) { (action) in
            
            // 설정된 시간 가져옴
            
            myDatePicker.datePickerMode = UIDatePickerMode.date
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
                
//                if(error!=nil){
//
//                    print("노티를 설정하는데 에러가 발생했습니다 :\(String(describing: error))")
//
//                }
                
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
        let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn, gestureDismissal: true) {
            
        }
        
        // Create buttons
        let confirmButton = DefaultButton(title: "확인") {
            
//            if(self.isNotiAllow() == true){
//                self.presentTimerAlert()
//            }else{
//                print("노티가 허용되지 않음")
//                self.setNotiAuth()
//            }
            
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
        
        // Prepare the popup assets
        let title = "이미 설정된 알림이 있습니다"
        let message = "삭제하거나 변경하겠습니까?"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn, gestureDismissal: true) {
            
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
        
        NotificationCenter.default.post(name: Constants.observer.requestSave, object: nil)
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
        
        let infoViewController = self.storyboard!.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        let navController = UINavigationController(rootViewController: infoViewController) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
        
    }
    
    
    @IBAction func onMenuPopButton(_ sender: Any) {
        
        let eventName = "onMenuPopButton"
        FBSDKAppEvents.logEvent(eventName)
        log.verbose(eventName)
        NotificationCenter.default.post(name: Constants.observer.requestMenuPop, object: nil)
        
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
    
//
//    func isNotiAllow() {
//        
//        
//        let center = UNUserNotificationCenter.current()
//        
//        center.getNotificationSettings { (settings) in
//            
//            if settings.authorizationStatus != .authorized {
//                // Notifications not allowed
//                
//                
//            }
//            
//        }
//        
//    }

}
