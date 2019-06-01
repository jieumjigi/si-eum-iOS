//
//  UIResponder+Extension.swift
//  sieum
//
//  Created by seongho on 07/02/2019.
//  Copyright © 2019 홍성호. All rights reserved.
//

import UIKit

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
