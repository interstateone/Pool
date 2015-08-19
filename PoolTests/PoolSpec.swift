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
        var pool: Pool<DemoPoolNotificationManager>!
        var vc: DemoViewController!

        beforeEach {
            pool = Pool<DemoPoolNotificationManager>()
            vc = DemoViewController(notificationManager: pool.notificationManager)
        }

        describe(".Login") {
            beforeEach {
                pool.run(LoginOperation(email: "user@example.com", password: "password123"))
            }

            it("should notify the VC of login with user") {
                expect(vc.loggedInUser).toEventuallyNot(beNil())
            }
        }

        describe(".Logout") {
            beforeEach {
                pool.run(LogoutOperation())
            }

            it("should notify the VC of logout") {
                expect(vc.loggedOutWasCalled).toEventually(beTrue())
            }
        }
    }
}
