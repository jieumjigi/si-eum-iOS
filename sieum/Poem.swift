//
//  Poem.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 23..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import ObjectMapper

struct Poem: ImmutableMappable {
    let identifier: String
    let reservationDate: Date?
    let authorID: String?
    let title: String?
    let content: String?
    let abbrev: String?
    let book: String?
    let publisher: String?
    let publishedDate: Date?
    
    init(map: Map) throws {
        self.identifier = try map.value(Poem.firebaseIdKey)
        self.authorID = try? map.value("author")
        self.title = try? map.value("title")
        self.content = try? map.value("content", using: UnescapingNewLineStringTrasnform())
        self.abbrev = try? map.value("abbrev")
        self.book = try? map.value("book")
        self.publisher = try? map.value("publisher")
        self.reservationDate = try? map.value("register_date", using: FirebaseDateFormatterTrasnform(components: [.date, .time]))
        self.publishedDate = try? map.value("reservation_date", using: FirebaseDateFormatterTrasnform(components: [.date,. time]))
    }
}
