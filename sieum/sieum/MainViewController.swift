//
//  MainViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let MENU_HEIGHT = CGFloat.init(330)
    let MENU_HEAD_HEIGHT = CGFloat.init(50)

    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTopMargin: NSLayoutConstraint!

    var screenSize = CGRect.init()
    var screenHeight = CGFloat.init()
    var screenWidth = CGFloat.init()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.addObserver()
        self.setLayout()
        
//        log.verbose("viewDidLoad")

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
//        log.verbose("viewDidAppear")
        
    }
    
    override func loadViewIfNeeded() {
        
        super.loadViewIfNeeded()
        log.verbose("loadViewIfNeeded")
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func panMenuView(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        var menuPositionY = sender.view!.center.y + translation.y
        
        if(menuPositionY < screenHeight - MENU_HEIGHT + MENU_HEIGHT/2){
            menuPositionY = screenHeight - MENU_HEIGHT + MENU_HEIGHT/2
        }
        
        if(menuPositionY > screenHeight - MENU_HEAD_HEIGHT + MENU_HEIGHT/2 ){
            menuPositionY = screenHeight - MENU_HEAD_HEIGHT + MENU_HEIGHT/2
        }
        
//        if(menuPositionY < screenHeight - MENU_HEIGHT){
//            menuPositionY = screenHeight - MENU_HEIGHT
//        }
//        
//        if(menuPositionY > screenHeight - MENU_HEAD_HEIGHT){
//            menuPositionY = screenHeight - MENU_HEAD_HEIGHT
//        }
        
        let movePoint = CGPoint(x: sender.view!.center.x, y: menuPositionY)
        
        sender.view!.center = movePoint
        sender.setTranslation(CGPoint.zero, in: self.view)
        
    }
    
    
    
    
    func setLayout(){
        
        self.screenSize = UIScreen.main.bounds
        self.screenHeight = screenSize.height
        self.screenWidth = screenSize.width
        self.menuTopMargin.constant = self.screenHeight - MENU_HEAD_HEIGHT - 16
        
    }
    
    func addObserver(){
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didMenuPop),
            name: Constants.observer.requestMenuPop ,
            object: nil)
    
    }

    func didMenuPop(){
        
        print("didMenuPop")
        
        var menuPositionY = self.menuView.center.y
        
        if( menuPositionY == screenHeight - MENU_HEIGHT + MENU_HEIGHT/2){
            
            menuPositionY = screenHeight - MENU_HEAD_HEIGHT + MENU_HEIGHT/2
//            NotificationCenter.default.post(name: Constants.observer.didMenuClose, object: nil)
            
        }else{
            
            menuPositionY = screenHeight - MENU_HEIGHT + MENU_HEIGHT/2
//            NotificationCenter.default.post(name: Constants.observer.didMenuOpen, object: nil)

        }

        
        let movePoint = CGPoint(x: self.menuView.center.x, y: menuPositionY)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {

            self.menuView.center = movePoint
            
        }, completion: { finished in

        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
