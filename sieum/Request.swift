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

enum APIError: Error {
    case emptyResponse
}

class DatabaseService {
    
    private enum Constants {
        static let defulatUserLevel: Int = 9
    }
    
    private let reference: DatabaseReference
    
    init(reference: DatabaseReference = Database.database().reference()) {
        self.reference = reference
    }
    
    func user(id: String) -> Observable<Result<User?>> {
        return reference.child("users")
            .child(id)
            .rx
            .observeSingleEvent(of: .value)
            .map{
                if let user = User(snapshot: $0) {
                    return .success(user)
                } else {
                    return .failure(APIError.emptyResponse)
                }
            }.catchError({ error in
                Observable.just(.failure(error))
            })
    }

    func poets() -> Observable<[User]> {
//        return reference.child("users")
//            .queryOrdered(byChild: "level")
//            .queryRange(in: 1...7, childKey: "level")
//            .rx
//            .observeSingleEvent(of: .value)
//            .map(Mapper<User>().mapArray)
        return Observable.just([]) // TODO
    }
    
    func poems() -> Observable<Result<[Poem]>> {
        return reference.child("poems")
            .rx
            .observeSingleEvent(of: .value)
            .map(Mapper<Poem>().mapArray)
            .map {
                .success($0)
            }.catchError({ error in
                Observable.just(.failure(error))
            })
    }
    
    func poems(of userID: String) -> Observable<[Poem]> {
//        return reference.child("poems")
//            .queryOrdered(byChild: "author")
//            .queryStarting(atValue: userID - 1, childKey: "author")
//            .queryEnding(atValue: userID, childKey: "author")
//            .rx
//            .observeSingleEvent(of: .value)
//            .map(Mapper<Poem>().mapArray)
        return Observable.just([]) // TODO
    }
    
    var todayPoem: Observable<Poem> {
//        return reference.child("poems")
//            .queryOrdered(byChild: "reservation_date")
//            .queryEnding(atValue: Date().today?.formattedText, childKey: "reservation_date")
//            .queryLimited(toLast: 1)
//            .rx
//            .observeSingleEvent(of: .value)
//            .map(Mapper<Poem>().mapArray)
//            .map{
//                if $0.isNotEmpty {
//                    return $0[0]
//                }
//                return nil
//            }.unwrap()
        return Observable.just(nil).unwrap() // TODO
    }
    
    func isPoet(userID: String) -> Observable<Bool> {
//        return Observable.create { observer in
//            self.reference.child("users")
//                .child(userID)
//                .observeSingleEvent(of: .value, with: { snapshot in
//                    if let user = User(snapshot: snapshot) {
//                        observer.onNext(user.level < 9)
//                    } else {
//                        observer.onNext(false)
//                    }
//                    observer.onCompleted()
//                })
//            return Disposables.create()
//        }
        return Observable.just(nil).unwrap() // TODO
    }
}

extension DatabaseService {
    func isUserIDRegistred(_ userID: String) -> Observable<Bool> {
        return reference.child("users")
            .child(userID)
            .rx
            .observeSingleEvent(of: .value)
            .debug()
            .map { snapshot in
                return snapshot.exists()
            }
    }
    
    func registerUserIfNeeded(profile: FBSDKProfile) -> Observable<Void> {
        return isUserIDRegistred(profile.userID)
            .filter { !$0 }
            .map { _ in }
            .do(onNext: { [weak self] in
                self?.register(profile: profile)
            })
    }
    
    func register(profile: FBSDKProfile, completion: ((Error?, DatabaseReference) -> Void)? = nil) {
        reference.child("users")
            .child(profile.userID)
            .setValue(["name": profile.name,
                       "level": Constants.defulatUserLevel,
                       "profile_img": profile.imageURL(for: .normal, size: CGSize(width: 100, height: 100)).absoluteString]) { error, databaseReference in
                        completion?(error, databaseReference)
        }
    }
    
    func unregister(userID: String, completion: ((Error?, DatabaseReference) -> Void)? = nil) {
        reference.child("users")
            .child(userID)
            .removeValue { error, databaseReference in
                completion?(error, databaseReference)
            }
    }
}
