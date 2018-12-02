//
//  DatabaseServiceTests.swift
//  sieumTests
//
//  Created by seongho on 30/11/2018.
//  Copyright © 2018 홍성호. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import sieum
@testable import FBSDKLoginKit
@testable import FirebaseDatabase

class DatabaseServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRegisterUser() {
        
    }

    func testRequestUser_wrongID() {
        DatabaseService(reference: DatabaseReference())
        
        let result: Result<User?> = try! Request.user(id: "1232131232")
            .toBlocking()
            .toArray()
            .first!
        
        XCTAssertTrue(result.isFailure)
    }
    
    func testRequestUser_registeredID() {
        // when
        let result = try! Request.user(id: "000000000000000")
            .toBlocking()
            .first()!
        
        // then
        XCTAssertTrue(result.isSuccess)
        XCTAssertTrue(result.value??.level == 9)
        XCTAssertTrue(result.value??.name == "name")
    }
}
