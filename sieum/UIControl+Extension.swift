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
    func addTarget(for controlEvents: UIControlEvents, _ onEvent: @escaping () -> Void) {
        let sleeve = ClosureSleeve(onEvent)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
