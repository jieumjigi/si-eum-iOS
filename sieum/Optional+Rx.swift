//
//  Optional+Rx.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 23..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import RxSwift

/// Represent an optional value
///
/// This is needed to restrict our Observable extension to Observable that generate
/// .Next events with Optional payload
protocol OptionalType {
    associatedtype Wrapped
    var asOptional: Wrapped? { get }
}

/// Implementation of the OptionalType protocol by the Optional type
extension Optional: OptionalType {
    var asOptional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
    /// Returns an Observable where the nil values from the original Observable are
    /// skipped
    func unwrappedOptional() -> Observable<Element.Wrapped> {
        return self.filter { $0.asOptional != nil }.map { $0.asOptional! }
    }
}
