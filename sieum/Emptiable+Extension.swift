//
//  Emptiable+Extension.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 8..
//  Copyright © 2018년 홍성호. All rights reserved.
//
//  https://github.com/artsy/Emergence/blob/master/Emergence/Extensions/Apple/Occupyable%2BisNotEmpty.swift
//

import Foundation

public protocol Emptiable {
    var isEmpty: Bool { get }
    var isNotEmpty: Bool { get }
}

extension Emptiable {
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String: Emptiable { }
extension Array: Emptiable { }
extension Dictionary: Emptiable { }
extension Set: Emptiable { }
extension Optional where Wrapped: Emptiable {
    public var isNilOrEmtpy: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isEmpty
        }
    }
    
    public var isNotNilNotEmpty: Bool {
        return !isNilOrEmtpy
    }
}
