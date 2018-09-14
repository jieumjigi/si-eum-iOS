//
//  User.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 21..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import ObjectMapper

class User: ImmutableMappable {
    
    var identifier: Int?
    let uid: String?
    let level: Int?
    let name: String?
    let introduce: String?
    let imageURLString: String?
    let snsURLString: String?
    
    required init(map: Map) throws {
//        identifier = try? map.value(User.firebaseIdKey)
        identifier = try? map.value("id")
        uid = try map.value("uid")
        level = try? map.value("level")
        name = try? map.value("name")
        introduce = try? map.value("introduce")
        imageURLString = try? map.value("profile_img")
        snsURLString = try? map.value("sns_url")
    }
}
