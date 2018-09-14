//
//  Poem.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 23..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import ObjectMapper

class Poem: Mappable {

    var identifier: Int?
    var reservationDate: Date?
    var authorID: Int?
    var title: String?
    var contents: String?
    var question: String?
    var book: String?
    var publisher: String?
    var publishedDate: Date?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        authorID <- map["author"]
        title <- map["title"]
        contents <- map["contents"]
        question <- map["question"]
        book <- map["book"]
        publisher <- map["publisher"]

        reservationDate <- (map["reservation_date"], FirebaseDateFormatterTrasnform())
        publishedDate <- (map["published_date"], FirebaseDateFormatterTrasnform())
    }
}
