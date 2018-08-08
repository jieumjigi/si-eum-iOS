//
//  EmptiableTests.swift
//  sieumTests
//
//  Created by 홍성호 on 2018. 8. 8..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import XCTest

class EmptiableTests: XCTestCase {
    
    func testStringIsNotEmpty() {
        let text = "hello"
        XCTAssertEqual(text.isNotEmpty, true)
        XCTAssertEqual(text.isEmpty, false)
    }
    
    func testStringIsEmpty() {
        let text = ""
        XCTAssertEqual(text.isNotEmpty, false)
        XCTAssertEqual(text.isEmpty, true)
    }
    
    func testOptionalStringIsNotNilOrEmpty() {
        let text: String? = "hello"
        XCTAssertEqual(text.isNilOrEmtpy, false)
        XCTAssertEqual(text.isNotNilNotEmpty, true)
    }
    
    func testOptionalStringIsEmpty() {
        var text: String?
        XCTAssertEqual(text.isNilOrEmtpy, true)
        XCTAssertEqual(text.isNotNilNotEmpty, false)
        
        text = ""
        XCTAssertEqual(text.isNilOrEmtpy, true)
        XCTAssertEqual(text.isNotNilNotEmpty, false)
    }
    
    func testArrayIsNotEmpty() {
        let array = [1, 2, 3]
        XCTAssertEqual(array.isNotEmpty, true)
        XCTAssertEqual(array.isEmpty, false)
    }
    
    func testArrayIsEmpty() {
        let array: [Int] = []
        XCTAssertEqual(array.isNotEmpty, false)
        XCTAssertEqual(array.isEmpty, true)
    }
}
