//
//  Date+Extension.swift
//  sieum
//
//  Created by seongho on 02/12/2018.
//  Copyright © 2018 홍성호. All rights reserved.
//

import Foundation

extension Date {
    func toString(components: Set<KRDateFormatter.Component> = Set<KRDateFormatter.Component>(KRDateFormatter.Component.allCases)) -> String {
        return KRDateFormatter(components: components).string(from: self)
    }
    
    func timeRemoved() -> Date? {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
}

class KRDateFormatter: DateFormatter {
    enum Component: CaseIterable {
        case date
        case time
    }
    
    init(components: Set<Component> = Set<Component>(Component.allCases)) {
        super.init()
        var dateFormat: String = ""
        if components.contains(.date) {
            dateFormat += "yyyy-MM-dd"
        }
        if components.contains(.time) {
            if components.contains(.date) {
                dateFormat += " "
            }
            dateFormat += "HH:mm"
        }
        self.dateFormat = dateFormat
        timeZone = TimeZone(abbreviation: "KST")
        locale = Locale(identifier: "ko_kr")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
