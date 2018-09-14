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
    
    static func poet(byID id: Int) -> Observable<User> {
        return reference.child("users")
            .queryOrdered(byChild: "id")
            .queryStarting(atValue: id - 1, childKey: "id")
            .queryEnding(atValue: id, childKey: "id")
            .rx
            .observeSingleEvent(of: .value)
            .map(Mapper<User>().mapArray)
            .map{
                if $0.isNotEmpty {
                    return $0[0]
                }
                return nil
            }.unwrap()
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
            .queryOrdered(byChild: "author")
            .queryStarting(atValue: userID - 1, childKey: "author")
            .queryEnding(atValue: userID, childKey: "author")
            .rx
            .observeSingleEvent(of: .value)
            .map(Mapper<Poem>().mapArray)
    }
    
    static var todayPoem: Observable<Poem> {
        return reference.child("poems")
            .queryOrdered(byChild: "reservation_date")
            .queryEnding(atValue: Date().today?.formattedText, childKey: "reservation_date")
            .queryLimited(toLast: 1)
            .rx
            .observeSingleEvent(of: .value)
            .map(Mapper<Poem>().mapArray)
            .map{
                if $0.isNotEmpty {
                    return $0[0]
                }
                return nil
            }.unwrap()
    }
    
//    static func isPoet(userID: Int)
    
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
            .queryOrdered(byChild: "uid")
            .queryStarting(atValue: profile.userID, childKey: "uid")
            .queryEnding(atValue: profile.userID, childKey: "uid")
            .queryLimited(toLast: 1)
            .rx
            .observeSingleEvent(of: .value)
            .do(onNext: { response in
                print("response: \(response)")
            }, onError: { error in
                print("error: \(error)")
            })
            .map(Mapper<User>().mapArray)
            .map{
                $0.isNotEmpty
            }
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
            .child(profile.userID)
            .setValue(["uid": profile.userID,
                       "name": profile.name,
                       "profile_img": profile.imageURL(for: .normal, size: CGSize(width: 100, height: 100)).absoluteString])
    }
}
