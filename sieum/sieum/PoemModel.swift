//
//  PoemModel.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 17..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import Alamofire

class PoemModel: NSObject {
    
    static let shared = PoemModel()
    
    private override init(){
        
        super.init()
        
    }
    
    var poemId : String? = ""
    var pushDueDate : String? = ""
    
    var title : String? = ""
    var poetName : String? = ""
    var contents : String? = ""
    var question : String? = ""
    
    var introPoet : String? = ""
    var linkToBook : String? = ""
    
    func parse(response:DataResponse<Any>){
        
        //to get JSON return value
        if let result = response.result.value {
            let json = result as! NSDictionary
            log.info(json)
            
            if let items = json["poem"] as? NSArray {
                
                if (items.count == 0){
                    return
                }
                
                if let items = items[0] as? NSDictionary {
                    
                    // 첫 페이지
                    
                    if let title = items["title"] as? String{
                        self.title = title
                    }else{
                        self.title = ""
                    }
                    
                    if let poetName = items["poetName"] as? String{
                        self.poetName = poetName
                    }else{
                        self.poetName = ""
                    }
                    
                    if let contents = items["contents"] as? String{
                        self.contents = contents
                    }else{
                        self.contents = ""
                    }
                    
                    // 두번째 페이지
                    
                    if let question = items["question"] as? String{
                        self.question = question
                    }else{
                        self.question = ""
                    }
                    
                    // 세번째 페이지
                    
                    if let linkToBook = items["linkToBook"] as? String{
                        self.linkToBook = linkToBook
                    }else{
                        self.linkToBook = ""
                    }
                    
                    if let introPoet = items["introPoet"] as? String{
                        self.introPoet = introPoet
                    }else{
                        self.introPoet = ""
                    }
                    
                }
            }
        }

        
    }
    
}
