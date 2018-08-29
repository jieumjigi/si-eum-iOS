//
//  LoginKit.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 29..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import FBSDKLoginKit

enum LoginCompletionType {
    case success(FBSDKLoginManagerLoginResult)
    case fail(Error?)
    case cancel
}

class LoginKit {
    
    static var isLoggedIn: Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    static func fetchName(completion: @escaping ((String?) -> Void)) {
        FBSDKProfile.loadCurrentProfile { profile, error in
            guard error == nil, let profile = profile else {
                completion(nil)
                return
            }
            return completion((profile.lastName ?? "") + " " + (profile.firstName ?? ""))
        }
    }
    
    static func login(from viewController: UIViewController?,
                             completion: ((LoginCompletionType) -> Void)? = nil) {
        guard let viewController = viewController else {
            return
        }
        
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"],
                                  from: viewController)
        { result, error in
            guard error == nil else {
                completion?(.fail(error))
                return
            }
            
            guard let result = result else {
                completion?(.fail(nil))
                return
            }
            
            if result.isCancelled {
                completion?(.cancel)
            } else {
                // result 정상일 때 Firebase에 저장하기
                completion?(.success(result))
            }
        }
    }
    
    static func logout() {
        FBSDKLoginManager().logOut()
    }
}
