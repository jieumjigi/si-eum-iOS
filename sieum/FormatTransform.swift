//
//  FormatTransform.swift
//  sieum
//
//  Created by 홍성호 on 2018. 9. 14..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import ObjectMapper

final class FirebaseDateFormatterTrasnform: DateFormatterTransform {
    
    init() {
        super.init(dateFormatter: DateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss", locale: "ko-KR"))
    }
}

