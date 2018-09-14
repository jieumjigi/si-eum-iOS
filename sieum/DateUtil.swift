//
//  DateUtil.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 12..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class DateUtil: NSObject {
    static func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        return result
    }
}

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    var today: Date? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)
    }
    
    var formattedText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.string(from: self)
    }
}
