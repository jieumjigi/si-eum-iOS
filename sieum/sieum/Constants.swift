//
//  Constant.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 24..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import Foundation

struct Constants {
    
    struct url {
//        static let base = "https://si-eum.appspot.com/poem/getPoem?"
        static let base = "https://si-eum-165814.appspot.com/"
//        static let base = "https://si-eum-petercha90.c9users.io/"
        static let blog = "https://jieumjigi.github.io"
        static let webSite = "https://jieumjigi.github.io/si-eum-web/"
    }
    
    struct observer {
        static let requestSave = NSNotification.Name(rawValue: "REQUEST_SAVE")
        static let requestShare = NSNotification.Name(rawValue: "REQUEST_SHARE")
        static let requestTimer = NSNotification.Name(rawValue: "REQUEST_TIMER")
        static let requestInfo = NSNotification.Name(rawValue: "REQUEST_INFO")
    }
}
