//
//  UIButton+Extension.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 15..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import UIKit

enum BarButtonType {
    case menu
    case write
}

extension UIButton {
    convenience init(for type: BarButtonType, onEvent: @escaping () -> Void) {
        self.init(type: .custom)
        frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        addTarget(for: .touchUpInside, onEvent)
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .zero

        switch type {
        case .menu:
            setImage(#imageLiteral(resourceName: "menu_icon"), for: .normal)
        case .write:
            setImage(#imageLiteral(resourceName: "write_icon"), for: .normal)
        }
    }
}

extension UIBarButtonItem {
    convenience init(for type: BarButtonType, onEvent: @escaping () -> Void) {
        self.init(customView: UIButton(for: type, onEvent: onEvent))
    }
}
