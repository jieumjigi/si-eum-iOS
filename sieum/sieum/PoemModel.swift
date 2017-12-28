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

class PoemModel: NSObject {
    
    static let shared = PoemModel()
    
    private override init(){
        
        super.init()
        
    }
    
    var poemId : String? = ""
    var reservation_date : String? = ""
    
    var title : String? = ""
    var authorName : String? = ""
    var contents : String? = ""
    var question : String? = ""
    
    var introduction : String? = ""
    var link : String? = ""
    
    func parse(json:JSON){
    
        // 첫 페이지
        if let title = json["title"].string{
            self.title = title
        }else{
            self.title = ""
        }

        if let authorName = json["authorName"].string{
            self.authorName = authorName
        }else{
            self.authorName = ""
        }

        if let contents = json["contents"].string{
            self.contents = contents
        }else{
            self.contents = ""
        }

        // 두번째 페이지

        if let question = json["question"].string{
            self.question = question
        }else{
            self.question = ""
        }

        // 세번째 페이지

        if let link = json["link"].string{
            self.link = link
        }else{
            self.link = ""
        }

        if let introduction = json["introduction"].string{
            self.introduction = introduction
        }else{
            self.introduction = ""
        }
    }
}
