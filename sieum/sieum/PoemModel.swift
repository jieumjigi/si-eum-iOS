//
//  PoemModel.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 17..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class PoemModel: NSObject {
    
    static let shared = PoemModel()
    
    private override init(){
        
        super.init()
        
    }
    
    var poemId : String?
    var pushDueDate : String?
    
    var title : String?
    var poetName : String?
    var contents : String?
    var question : String?
    
    var introPoet : String?
    var linkToBook : String?
    
    func parse(){
        
        
    }
    
}
