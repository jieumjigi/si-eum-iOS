//
//  DateUtil.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 12..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class DateUtil: NSObject {
    
    public func getDate() -> String{
    
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        return result
    
    }

}
