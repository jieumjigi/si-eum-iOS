//
//  DateUtil.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 12..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    static var today: Date? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return Calendar.current.date(from: components)
    }
    
    static var yesterday: Date? {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        if let day = components.day {
            components.day = day - 1
        }
        return Calendar.current.date(from: components)
    }
    
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: self)
        return result
    }
}
