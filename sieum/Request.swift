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
import FBSDKLoginKit

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

extension Request {
    
    static func isUserIDRegistred(profile: FBSDKProfile) -> Observable<Bool> {
        return reference.child("users")
            .queryEqual(toValue: "uid", childKey: profile.userID)
            .rx
            .observeSingleEvent(of: .value)
            .map { Poem(snapshot: $0) }
            .map { return $0 != nil }
    }
    
    static func registerUserIDIfNeeded(profile: FBSDKProfile) -> Observable<Void> {
        return Request.isUserIDRegistred(profile: profile)
            .filter { !$0 }
            .map { _ in }
            .do(onNext:{ _ in
                Request.register(profile: profile)
            })
    }
    
    static func register(profile: FBSDKProfile) {
        reference.child("users")
            .childByAutoId()
            .setValue(["uid": profile.userID,
                       "name": profile.name,
                       "profile_img": profile.imageURL(for: .normal, size: CGSize(width: 100, height: 100)).absoluteString])
    }
}
