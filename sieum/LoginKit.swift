//
//  LoginKit.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 29..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import RxSwift
import RxCocoa
import RxSwiftExt

enum LoginCompletionType {
    case success(FBSDKLoginManagerLoginResult)
    case fail(Error?)
    case cancel
}

enum LoginKitError: Error {
    case profileNotExist
}

class LoginKit {
    
    static var isLoggedIn: Bool {
        return FBSDKAccessToken.current() != nil
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

extension LoginKit {
    
    static func didProfileChanged() -> Observable<FBSDKProfile?> {
        return NotificationCenter.default.rx
            .notification(NSNotification.Name.FBSDKProfileDidChange)
            .map { notification in
                print("userInfo: \(String(describing: notification.userInfo?[FBSDKProfileChangeNewKey]))")
                guard let userInfo = notification.userInfo, let profile = userInfo[FBSDKProfileChangeNewKey] as? FBSDKProfile else {
                    return nil
                }
                return profile
            }
    }
    
    static func syncUserIDWithFirebaseDB() {
        LoginKit.didProfileChanged()
            .unwrap()
            .flatMapLatest(Request.isUserIDRegistred) // 비동기로 DB에 등록여부 체크
            .filter { $0 }
            // profile 을 가지고 DB에 업로드 func 실행
    }
    
    static func syncUserIDWithFirebase() {
        
    }
}

extension LoginKit {
    
    static func profile() -> Observable<FBSDKProfile> {
        return Observable<FBSDKProfile>.create { observer in
            FBSDKProfile.loadCurrentProfile(completion: { profile, error in
                guard error == nil, let profile = profile else {
                    return observer.onError(LoginKitError.profileNotExist)
                }
                return observer.onNext(profile)
            })
            return Disposables.create()
        }
    }
    
    static func fetchName(completion: @escaping ((String?) -> Void)) {
        FBSDKProfile.loadCurrentProfile { profile, error in
            guard error == nil, let profile = profile else {
                completion(nil)
                return
            }
            
            return completion(profile.name)
        }
    }
    
    static func imageURL(size: CGSize) -> Observable<URL?> {
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        return NotificationCenter.default.rx
            .notification(NSNotification.Name.FBSDKProfileDidChange)
            .map { _ in
                return FBSDKProfile.current()?.imageURL(for: .normal, size: size)
            }
    }
}
