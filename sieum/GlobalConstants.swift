//
//  Constant.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 24..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import Foundation
import UIKit

enum GlobalConstants {
    
    enum URL {
        static let blog = "https://www.facebook.com/tasteapoem/"
    }
    
    enum observer {
        static let requestSave = NSNotification.Name(rawValue: "REQUEST_SAVE")
        static let requestShare = NSNotification.Name(rawValue: "REQUEST_SHARE")
        static let requestTimer = NSNotification.Name(rawValue: "REQUEST_TIMER")
        static let requestInfo = NSNotification.Name(rawValue: "REQUEST_INFO")
        static let requestMenuPop = NSNotification.Name(rawValue: "REQUEST_MENU_POP")
        
        static let didMenuOpen = NSNotification.Name(rawValue: "DID_MENU_OPEN")
        static let didMenuClose = NSNotification.Name(rawValue: "DID_MENU_CLOSE")
    }
    
    enum font {
        static let small: CGFloat = 12.0
        static let medium: CGFloat = 14.0
        static let large: CGFloat = 16.0
    }
}
