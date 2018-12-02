//
//  DatabaseReferenceProtocol.swift
//  sieum
//
//  Created by seongho on 02/12/2018.
//  Copyright © 2018 홍성호. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol DatabaseReferenceProtocol {
    func observeSingleEvent(of eventType: DataEventType, with block: (DataSnapshot) -> Void, withCancel cancelBlock: ((Error) -> Void)?)
    func observe(_ eventType: DataEventType, with: (DataSnapshot) -> Void, withCancel: ((Error) -> Void)?)
}

extension DatabaseReference: DatabaseReferenceProtocol {
    func observeSingleEvent(of eventType: DataEventType, with block: (DataSnapshot) -> Void, withCancel cancelBlock: ((Error) -> Void)?) {
        self.observeSingleEvent(of: eventType, with: block, withCancel: cancelBlock)
    }
    
    func observe(_ eventType: DataEventType, with block: (DataSnapshot) -> Void, withCancel cancelBlock: ((Error) -> Void)?) {
        self.observe(eventType, with: block, withCancel: cancelBlock)
    }
}
