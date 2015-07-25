//
//  PoolTests.swift
//  PoolTests
//
//  Created by Brandon Evans on 2015-07-24.
//  Copyright © 2015 Brandon Evans. All rights reserved.
//

import Quick
import Nimble
@testable import Pool

class PoolSpec: QuickSpec {
    override func spec() {
        var pool: Pool<DemoOperation>!
        var vc: DemoViewController!

        beforeEach {
            pool = Pool<DemoOperation>()
            vc = DemoViewController(pool: pool)
        }

        describe(".Login") {
            beforeEach {
                pool.run(.Login("user@example.com", "password123"))
            }

            it("should notify the VC of login with user") {
                expect(vc.loggedInUser).notTo(beNil())
            }
        }

        describe(".Logout") {
            beforeEach {
                pool.run(.Logout)
            }

            it("should notify the VC of logout") {
                expect(vc.loggedOutWasCalled).to(beTrue())
            }
        }
    }
}
