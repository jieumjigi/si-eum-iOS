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
    
    private enum Constants {
        static let defulatUserLevel: Int = 9
    }
    
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
    
    static func poems() -> Observable<[Poem]> {
        return reference.child("poems")
            .rx
            .observeSingleEvent(of: .value)
            .map(Mapper<Poem>().mapArray)
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
    
    static func isPoet(userID: String) -> Observable<Bool> {
        return Observable.create { observer in
            self.reference.child("users")
                .child(userID)
                .observeSingleEvent(of: .value, with: { snapshot in
                    if let user = User(snapshot: snapshot),
                        let level = user.level {
                        observer.onNext(level < 9)
                    } else {
                        observer.onNext(false)
                    }
                    observer.onCompleted()
                })
            return Disposables.create()
        }
    }
}

extension Request {
    static func isUserIDRegistred(_ userID: String) -> Observable<Bool> {
        return reference.child("users")
            .child(userID)
            .rx
            .observeSingleEvent(of: .value)
            .debug()
            .map { snapshot in
                return snapshot.exists()
            }
    }
    
    static func registerUserIfNeeded(profile: FBSDKProfile) -> Observable<Void> {
        return Request.isUserIDRegistred(profile.userID)
            .filter { !$0 }
            .map { _ in }
            .do(onNext: {
                Request.register(profile: profile)
            })
    }
    
    static func register(profile: FBSDKProfile) {
        reference.child("users")
            .child(profile.userID)
            .setValue(["name": profile.name,
                       "level": Constants.defulatUserLevel,
                       "profile_img": profile.imageURL(for: .normal, size: CGSize(width: 100, height: 100)).absoluteString])
    }
}
