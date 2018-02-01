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
  @IBOutlet weak var menuBottomMargin: NSLayoutConstraint!

  private var screenSize: CGRect {
    get {
      return UIScreen.main.bounds
    }
  }
  private var screenHeight: CGFloat {
    get {
      return screenSize.height
    }
  }
  
  private var screenWidth: CGFloat {
    get {
      return screenSize.width
    }
  }
  
  private var defaultMenuBottomConstnat: CGFloat {
    get {
      return MENU_HEAD_HEIGHT - menuView.frame.height - getBottomInset()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addObserver()
  }
  
  override func updateViewConstraints() {
    menuBottomMargin.constant = defaultMenuBottomConstnat
    super.updateViewConstraints()
  }
  
  @IBAction func panMenuView(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self.view)
    menuBottomMargin.constant -= translation.y

    if menuBottomMargin.constant < defaultMenuBottomConstnat {
      menuBottomMargin.constant = defaultMenuBottomConstnat
    }
    if menuBottomMargin.constant > -getBottomInset() {
      menuBottomMargin.constant = -getBottomInset()
    }
    sender.setTranslation(CGPoint.zero, in: self.view)
  }
  
  private func addObserver(){
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didMenuPop),
      name: Constants.observer.requestMenuPop ,
      object: nil)
  }
  
  func didMenuPop(){
    var menuPositionY = self.menuView.center.y
    if( menuPositionY == screenHeight - MENU_HEIGHT + MENU_HEIGHT/2){
      menuPositionY = screenHeight - MENU_HEAD_HEIGHT + MENU_HEIGHT/2
    }else{
      menuPositionY = screenHeight - MENU_HEIGHT + MENU_HEIGHT/2
    }
    
    let movePoint = CGPoint(x: self.menuView.center.x, y: menuPositionY)
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
      self.menuView.center = movePoint
    }, completion: nil)
  }
  
  private func getBottomInset() -> CGFloat {
    var bottomInset:CGFloat = 0.0
    if #available(iOS 11.0, *) {
      let safeAreaInsets = view.safeAreaInsets
      bottomInset = safeAreaInsets.bottom
    }
    return bottomInset
  }
}
