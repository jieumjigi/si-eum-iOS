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
    init(components: Set<KRDateFormatter.Component> = Set<KRDateFormatter.Component>(KRDateFormatter.Component.allCases)) {
        super.init(dateFormatter: KRDateFormatter(components: components))
    }
}

final class UnescapingNewLineStringTrasnform: TransformType {
    typealias Object = String
    typealias JSON = String
    
    init() {}
    func transformFromJSON(_ value: Any?) -> String? {
        if let strValue = value as? String {
            return strValue.replacingOccurrences(of: "\\n", with: "\n")
        }
        return value as? String
    }
    
    func transformToJSON(_ value: String?) -> String? {
        return value
    }
}

