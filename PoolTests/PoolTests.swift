//
//  PoolTests.swift
//  PoolTests
//
//  Created by Brandon Evans on 2015-07-24.
//  Copyright © 2015 Brandon Evans. All rights reserved.
//

import XCTest
@testable import Pool

class PoolTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let pool = Pool<DemoOperation>()
        
        let vc = DemoViewController(pool: pool)
        
        let email = "user@example.com"
        let password = "password123"
        
        XCTAssertNil(vc.loggedInUser)
        pool.run(.Login(email, password))
        XCTAssertNotNil(vc.loggedInUser)
        
        XCTAssertFalse(vc.loggedOutWasCalled)
        pool.run(.Logout)
        XCTAssertTrue(vc.loggedOutWasCalled)
    }
}
