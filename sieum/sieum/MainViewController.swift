//
//  MainViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let MENU_HEIGHT = CGFloat.init(350)
    let MENU_HEAD_HEIGHT = CGFloat.init(30)

    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTopMargin: NSLayoutConstraint!

    var screenSize = CGRect.init()
    var screenHeight = CGFloat.init()
    var screenWidth = CGFloat.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        // Do any additional setup after loading the view.
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
        
        
        let movePoint = CGPoint(x: sender.view!.center.x, y: menuPositionY)
        
        
        sender.view!.center = movePoint
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        

    }
    
    
    
    func setLayout(){
        
        self.screenSize = UIScreen.main.bounds
        self.screenHeight = screenSize.height
        self.screenWidth = screenSize.width
        
        self.menuTopMargin.constant = self.screenHeight - MENU_HEAD_HEIGHT
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
