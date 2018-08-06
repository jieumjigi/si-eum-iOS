//
//  PoemPageViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 7..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import SHSideMenu

class PoemPageViewController: BaseViewController, SideMenuUsable {

    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(onSideMenuButtonTouch(_:)))
    }
    
    @objc private func onSideMenuButtonTouch(_ sender: UIButton) {
        sideMenuAction.onNext(.open)
    }
}
