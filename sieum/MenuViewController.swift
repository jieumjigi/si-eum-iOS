//
//  MenuViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 7..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import SHSideMenu

class MenuViewController: UIViewController, ContentViewChangable {
    
    var viewTransition: BehaviorSubject<UIViewController> = BehaviorSubject<UIViewController>(value: UINavigationController(rootViewController: PoemPageViewController()))

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
