//
//  PoemModel.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 17..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct PoemPageModel {
    var poemID: String?
    var reservationDate: Date?
    
    var title: String?
    var authorName: String?
    var content: String?
    var abbrev: String?
    
    var introduction: String?
    var imageURLString: String?
    var snsURLString: String?
    
    init(poem: Poem, user: UserModel?) {
        poemID = poem.identifier
        reservationDate = poem.reservationDate
        title = poem.title
        content = poem.content
        abbrev = poem.abbrev
        
        authorName = user?.name
        introduction = user?.introduce
        imageURLString = user?.profileImageURLString
        snsURLString = user?.snsURLString
    }
}
