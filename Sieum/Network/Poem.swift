//
//  Poem.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 23..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseFirestore

struct Poem: ImmutableMappable {
    let identifier: String
    let userID: String
    let title: String?
    let content: String?
    let abbrev: String?
    let book: String?
    let publisher: String?
    let reservationDate: Date?
    let registerDate: Date?
    
    init(map: Map) throws {
        self.identifier = try map.value(Poem.firebaseIDKey)
        self.userID = try map.value("user_id")
        self.title = try? map.value("title")
        self.content = try? map.value("content", using: UnescapingNewLineStringTrasnform())
        self.abbrev = try? map.value("abbrev")
        self.book = try? map.value("book")
        self.publisher = try? map.value("publisher")
        self.reservationDate = try? ((map.value("reservation_date")) as Timestamp).dateValue()
        self.registerDate = try? ((map.value("register_date")) as Timestamp).dateValue()
    }
}
