//
//  User.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 21..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var identifier: Int?
    var uid: Int?
    var level: Int?
    var name: String?
    var introduce: String?
    var imageURLString: String?
    var snsURLString: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        uid <- map["uid"]
        level <- map["level"]
        name <- map["name"]
        introduce <- map["introduce"]
        imageURLString <- map["profile_img"]
        snsURLString <- map["sns_url"]
    }
}
