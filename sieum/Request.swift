//
//  Request.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 21..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import FirebaseDatabase
import ObjectMapper
import RxSwift

class Request {
    
    static var reference: DatabaseReference {
        return Database.database().reference()
    }
    
    static func poets() -> Observable<[User]> {
        return reference.child("users")
            .queryOrdered(byChild: "level")
            .queryRange(in: 1...7, childKey: "level")
            .rx
            .observeSingleEvent(of: .value)
            .map(Mapper<User>().mapArray)
    }
    
    static func poems(of userID: Int) -> Observable<[Poem]> {
        return reference.child("poems")
            .queryStarting(atValue: userID - 1, childKey: "author")
            .queryEnding(atValue: userID, childKey: "author")
            .queryOrdered(byChild: "author")
            .rx
            .observeSingleEvent(of: .value)
            .map(Mapper<Poem>().mapArray)
    }
    
    static var todayPoem: Observable<Poem> {
        return reference.child("poems")
            .queryStarting(atValue: "", childKey: "author")
            .queryLimited(toFirst: 1)
            .rx
            .observeSingleEvent(of: .value)
            .map { Poem(snapshot: $0) }
            .unwrappedOptional()
    }
    
//    static func poems(of userID: Int) -> Observable<[Poem]> {
//        return reference.child("poems")
//            .queryEqual(toValue: userID, childKey: "author")
//            .queryOrdered(byChild: "reservation_date")
//            .rx
//            .observeSingleEvent(of: .value)
//            .map(Mapper<Poem>().mapArray)
//    }
}
