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
import FirebaseFirestore

enum APIError: Error {
    case emptyResponse
    case invalidRequestParameter
    case mappingFail
}

extension BaseMappable {
    
    static var firebaseIDKey : String {
        return "firebaseIDKey"
    }
    
    init?(snapshot: DocumentSnapshot?) {
        guard let snapshot = snapshot,
            var json = snapshot.data() else {
                return nil
        }
        json[Self.firebaseIDKey] = snapshot.documentID as Any
        self.init(JSON: json)
    }
}

extension CollectionReference {
    func addDocument(optionalData: [String: Any?], completion: ((Error?) -> Void)? = nil) {
        let documentDataWithNullObject = optionalData.mapValues {
            return $0 ?? NSNull()
        }
        addDocument(data: documentDataWithNullObject, completion: completion)
    }
}

extension DocumentReference {
    func setData(optionalData: [String: Any?], completion: @escaping (Error?) -> Void) {
        let documentDataWithNullObject = optionalData.mapValues {
            return $0 ?? NSNull()
        }
        self.setData(documentDataWithNullObject) { error in
            completion(error)
        }
    }
    
    func getDocument<Response: BaseMappable>(completion: @escaping (Result<Response>) -> Void) {
        self.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let response = Response(snapshot: snapshot) else {
                    assertionFailure("mapping failure: \(String(describing: snapshot))")
                    return
                }
                completion(.success(response))
            }
        }
    }
}

protocol ArrayResultProtocol {
    associatedtype Element: BaseMappable
}
extension Array: ArrayResultProtocol where Element: BaseMappable { }


extension Query {
    func getDocuments<Response: ArrayResultProtocol>(completion: @escaping (Result<Response>) -> Void) {
        
        self.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let poems = snapshot?.documents.compactMap({ poem -> Response.Element? in
                    var json = poem.data()
                    json[Response.Element.firebaseIDKey] = poem.documentID
                    return Response.Element(JSON: json)
                }) as? Response {
                    completion(.success(poems))
                } else{
                    completion(.failure(APIError.mappingFail))
                }
            }
        }
    }
}

class DatabaseService {
    
    static let shared = DatabaseService()
    
    private let reference: DatabaseReference
    private let database: Firestore

    init(reference: DatabaseReference = Database.database().reference(),
         database: Firestore = Firestore.firestore()) {
        self.reference = reference
        self.database = database
    }
    
    func poets(completion: @escaping (Result<[UserModel]>) -> Void) {
        database.collection("users")
            .order(by: "level")
            .end(at: [7])
            .getDocuments { (result: Result<[UserModel]>) in
                completion(result)
        }
    }
    
    func user(identifier: String, completion: @escaping (Result<UserModel>) -> Void) {
        database.collection("users")
            .document(identifier)
            .getDocument { (result: Result<UserModel>) in
                completion(result)
        }
    }
    
    func todayPoem(completion: @escaping (Result<Poem>) -> Void) {
        database.collection("poems")
            .order(by: "reservation_date", descending: true)
            .whereField("reservation_date", isLessThanOrEqualTo: Date().timeRemoved())
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let poem = snapshot?.documents.compactMap({ poem -> Poem? in
                        var json = poem.data()
                        json[Poem.firebaseIDKey] = poem.documentID
                        return Poem(JSON: json)
                    }).first {
                        completion(.success(poem))
                    }
                }
        }
    }
    
    func poem(identifier: String, completion: @escaping (Result<Poem>) -> Void) {
        database.collection("poems")
            .document(identifier)
            .getDocument { (result: Result<Poem>) in
                completion(result)
        }
    }
    
    func poems(
        userID: String,
        lastPoem: Poem?,
        limit: Int,
        after afterDate: Date? = nil,
        completion: @escaping (Result<[Poem]>) -> Void) {
        
        var reference = database
            .collection("poems")
            .whereField("user_id", isEqualTo: userID)
            .limit(to: limit)
        
        if let afterDate = afterDate {
            reference = reference.whereField("reservation_date", isLessThan: afterDate)
        }

        if let lastPoem = lastPoem {
            if let reservationDate = lastPoem.reservationDate {
                reference = reference.whereField("reservation_date", isLessThan: reservationDate)
            } else {
                completion(.success([]))
            }
        }

        reference
            .order(by: "reservation_date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let poems = snapshot?.documents.compactMap { poem -> Poem? in
                        var json = poem.data()
                        json[Poem.firebaseIDKey] = poem.documentID
                        return Poem(JSON: json)
                        } ?? []
                    completion(.success(poems))
                }
        }
    }
    
    func isPoet(userID: String, completion: @escaping (Result<Bool>) -> Void) {
        database.collection("users")
            .document(userID)
            .getDocument { (result: Result<UserModel>) in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let user):
                    completion(.success(user.isPoet))
                }
            }
    }
}

extension DatabaseService {
    func isUserIDRegistered(userID: String, completion: @escaping (Result<Bool>) -> Void) {
        database.collection("users")
            .document(userID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if snapshot?.exists ?? false {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            }
    }
    
    func registerUserIfNeeded(with authUser: AuthUser?) {
        guard let authUser = authUser else {
            return
        }
        isUserIDRegistered(userID: authUser.identifier) { [weak self] result in
            switch result {
            case .failure:
                break
            case .success(let isRegistered):
                if isRegistered == false {
                    self?.register(authUser: authUser)
                }
            }
        }
    }
    
    func register(authUser: AuthUser, completion: ((Error?) -> Void)? = nil) {
        database.collection("users")
            .document(authUser.identifier)
            .setData(optionalData:
                [
                    "name": authUser.name,
                    "profile_img": authUser.imageURL?.absoluteString,
                    "level": UserModel.Constants.defulatUserLevel
                ]
            ) { error in
                completion?(error)
            }
    }
    
    func unregister(userID: String, completion: ((Error?, DatabaseReference) -> Void)? = nil) {
        reference.child("users")
            .child(userID)
            .removeValue { error, databaseReference in
                completion?(error, databaseReference)
            }
    }
    
    func addPoem(model: PoemWriteModel, userID: String, completion: @escaping (Error?) -> Void) {
        
        guard model.isUploadable else {
            return
        }
        
        database.collection("poems")
            .addDocument(optionalData:
                [
                    "user_id": userID,
                    "title": model.title,
                    "content": model.content,
                    "abbrev": model.abbrev,
                    "register_date": Date(),
                    "reservation_date": model.reservationDate
                ]
            ) { error in
                completion(error)
            }
    }
    
    func deletePoem(_ poem: Poem, completion: ((Error?) -> Void)? = nil) {
        database.collection("poems")
            .document(poem.identifier)
            .delete { error in
                completion?(error)
            }
    }
}
