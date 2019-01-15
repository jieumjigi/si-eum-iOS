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
    private var databaseService: DatabaseService!

    override func setUp() {
        databaseService = DatabaseService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRegisterUserID() {
        let userID = "000000000000000"
        let result = try! databaseService.user(id: userID)
            .toBlocking()
            .first()!
        
        XCTAssertTrue(result.isSuccess)
        XCTAssertTrue(result.value??.identifier == userID)
    }

    func testRequestUser_wrongID() {
        
        let result: Result<User?> = try! databaseService.user(id: "1232131232")
            .toBlocking()
            .toArray()
            .first!
        
        XCTAssertTrue(result.isFailure)
    }
    
    func testRequestUser_registeredID() {
        // when
        let result = try! databaseService.user(id: "000000000000000")
            .toBlocking()
            .first()!
        
        // then
        XCTAssertTrue(result.isSuccess)
    }
    
    func testIsPoet() {
        let isNotPoet = try! databaseService.isPoet(userID: "000000000000000")
            .toBlocking()
            .first()!
        
        XCTAssertFalse(isNotPoet)
        
        let notExistUser = try! databaseService.isPoet(userID: "000000000000001")
            .toBlocking()
            .first()!
        
        XCTAssertFalse(notExistUser)
    }
    
    func testTodayPoem() {
        let todayPoem = try! databaseService.todayPoem.toBlocking().first()
        XCTAssertTrue(todayPoem?.isSuccess ?? false)
    }
}
