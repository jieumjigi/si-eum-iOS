//
//  DatabaseQuery+Rx.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 22..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift

extension Reactive where Base: DatabaseReference {
    func observeSingleEvent(of event: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create({ observer in
            self.base.observeSingleEvent(of: event, with: { snapshot in
                observer.onNext(snapshot)
                observer.onCompleted()
            }, withCancel: { error in
                observer.onError(error)
            })
            return Disposables.create()
        })
    }
    
    func observeEvent(event: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create({ observer in
            let handle = self.base.observe(event, with: { snapshot in
                observer.onNext(snapshot)
            }, withCancel: { error in
                observer.onError(error)
            })
            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        })
    }
}
