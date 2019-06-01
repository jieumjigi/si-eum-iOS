//
//  LoginKit.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 29..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginService {
    
    static let shared = LoginService()
    
    private let auth: Auth
    
    init() {
        auth = Auth.auth()
    }
    
    static var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static var loginViewController: UIViewController? {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.providers = [
            FUIGoogleAuth(),
            FUIFacebookAuth()
        ]
        return authUI?.authViewController()
    }
    
    var currentUID: String? {
        return auth.currentUser?.uid
    }
    
    func didChangeUser(_ authUserHandler: @escaping (AuthUser?) -> Void) {
        auth.addStateDidChangeListener { auth, user in
            authUserHandler(AuthUser(user: user))
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
        } catch {
            
        }
    }
}

struct AuthUser {
    
    let identifier: String
    let name: String?
    let imageURL: URL?
    
    init?(user: User?) {
        guard let user = user else {
            return nil
        }
        identifier = user.uid
        name = user.displayName
        imageURL = user.photoURL
    }
}
