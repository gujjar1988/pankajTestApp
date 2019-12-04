//
//  TestTests.swift
//  TestTests
//
//  Created by Pankaj on 03/12/19.
//  Copyright © 2019 Pankaj. All rights reserved.
//

import XCTest
@testable import Test

class TestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testDateValues(){
        let dateStr = "05/11/2019"
        let newStr = changeDateStringWithFormat(dateStr, "dd/MM/yyyy", "dd-MM-yyyy")
        XCTAssertEqual(newStr, "05-11-2019", "Score computed from guess is wrong")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
