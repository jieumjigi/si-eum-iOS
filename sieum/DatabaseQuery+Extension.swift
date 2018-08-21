//
//  DatabaseQuery.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 22..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DatabaseQuery {
    func queryRange(in range: ClosedRange<Int>, childKey: String?) -> DatabaseQuery {
        return queryStarting(atValue: range.lowerBound - 1, childKey: childKey)
            .queryEnding(atValue: range.upperBound, childKey: childKey)
    }
}
