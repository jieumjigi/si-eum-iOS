//
//  User.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 21..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: ImmutableMappable {
    let identifier: String
    let name: String
    let level: Int
    let profileImageURLString: String?
    let introduce: String?
    let snsURLString: String?
    
    init(map: Map) throws {
        identifier = try map.value(User.firebaseIdKey)
        name = try map.value("name")
        level = try map.value("level")
        introduce = try? map.value("introduce")
        profileImageURLString = try? map.value("profile_img")
        snsURLString = try? map.value("sns_url")
    }
}
