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
    var poemID: Int?
    var reservationDate: Date?
    
    var title: String?
    var authorName: String?
    var content: String?
    var question: String?
    
    var introduction: String?
    var imageURLString: String?
    var snsURLString: String?
    
    init(poem: Poem, user: User) {
        poemID = poem.identifier
        reservationDate = poem.reservationDate
        title = poem.title
        authorName = user.name
        content = poem.content
        question = poem.question
        introduction = user.introduce
        imageURLString = user.profileImageURLString
        snsURLString = user.snsURLString
    }
}

class PoemModel: NSObject {
    
    static let shared = PoemModel()
    
    override init(){
        super.init()
    }
    
    var poemId : String? = ""
    var reservation_date : String? = ""
    
    var title : String? = ""
    var authorName : String? = ""
    var contents : String? = ""
    var question : String? = ""
    
    var introduction : String? = ""
    var profileImageLink: String? = ""
    var link : String? = ""
    
    func parse(json:JSON){
        
        // 첫 페이지
        if let title = json["title"].string{
            self.title = title
        } else {
            self.title = ""
        }
        
        if let authorName = json["authorName"].string{
            self.authorName = authorName
        } else {
            self.authorName = ""
        }
        
        if let contents = json["contents"].string{
            self.contents = contents
        } else {
            self.contents = ""
        }
        
        // 두번째 페이지
        
        if let question = json["question"].string{
            self.question = question
        } else {
            self.question = ""
        }
        
        // 세번째 페이지
        
        if let link = json["link"].string{
            self.link = link
        } else {
            self.link = ""
        }
        
        if let introduction = json["introduction"].string{
            self.introduction = introduction
        } else {
            self.introduction = ""
        }
        
        if let profileImageLink = json["profile_image_link"].string {
            self.profileImageLink = profileImageLink
        } else {
            self.profileImageLink = ""
        }
    }
}
