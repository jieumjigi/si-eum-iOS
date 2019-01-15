//
//  Mapper+Extension.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 22..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import FirebaseDatabase
import ObjectMapper

extension BaseMappable {
    static var firebaseIdKey : String {
        get {
            return "FirebaseIdKey"
        }
    }

    init?(snapshot: DataSnapshot) {
        guard var json = snapshot.value as? [String: Any] else {
            return nil
        }
        json[Self.firebaseIdKey] = snapshot.key as Any

        self.init(JSON: json)
    }
}

extension Mapper {
    func mapArray(snapshot: DataSnapshot) -> [N] {
        return snapshot.children.map({ child -> N? in
            if let childSnap = child as? DataSnapshot {
                return N(snapshot: childSnap)
            }
            return nil
        }).compactMap { $0 }
    }
}
