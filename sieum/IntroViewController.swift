//
//  IntroViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 6. 23..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit

class IntroViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: nil)
    }
}
