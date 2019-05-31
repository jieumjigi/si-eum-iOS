//
//  UIControl+Extension.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 15..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import UIKit

class ClosureSleeve {
    let closure: () -> Void
    
    init (_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addTarget(for controlEvents: UIControl.Event, _ onEvent: @escaping () -> Void) {
        let sleeve = ClosureSleeve(onEvent)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(arc4random())", sleeve, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIGestureRecognizer {
    convenience init(_ onEvent: @escaping () -> Void) {
        let sleeve = ClosureSleeve(onEvent)
        self.init(target: sleeve, action: #selector(ClosureSleeve.invoke))
        objc_setAssociatedObject(self, "\(arc4random())", sleeve, .OBJC_ASSOCIATION_RETAIN)
    }
}

enum GestureType {
    case tap
    case pan
}

extension UIView {
    func addGesture(type: GestureType, _ onEvent: @escaping () -> Void) {
        isUserInteractionEnabled = true
        
        var gesture: UIGestureRecognizer
        switch type {
        case .tap:
            gesture = UITapGestureRecognizer(onEvent)
        case .pan:
            gesture = UIPanGestureRecognizer(onEvent)
        }
        addGestureRecognizer(gesture)
    }
}
