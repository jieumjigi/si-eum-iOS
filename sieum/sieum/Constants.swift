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
        static let base = "https://si-eum-petercha90.c9users.io/poem/getPoem?"

    }
    
    struct observer {
        static let requestDownload = NSNotification.Name(rawValue: "REQUEST_DOWNLOAD")
    }
}
