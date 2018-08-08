//
//  UINavigationController+Extension.swift
//  sieum
//
//  Created by 홍성호 on 2018. 7. 31..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit

extension UINavigationController {
    func makeClearBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
