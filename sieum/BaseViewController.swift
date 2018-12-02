//
//  BaseViewController.swift
//  sieum
//
//  Created by seongho on 02/12/2018.
//  Copyright © 2018 홍성호. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
