import Foundation
import UIKit

// pretend with me
class SomeViewController: NSObject, DemoOperationObserver {

    // MARK: OperationObserver

    typealias Operation = DemoOperation

    var pool: Pool<Operation>

    // MARK: DemoOperationObserver

    func loggedInWithUser(user: User) {
        // Run some operations
        loggedInWithUser = user
        print("login observed")
    }

    func loggedOut() {
        // Run some others
        loggedOutWasCalled = true
        print("logout observed")
    }

    // MARK: -

    init(pool: Pool<Operation>) {
        self.pool = pool
        super.init()
        registerForNotifications()
    }

    // MARK: Example mocks

    var loggedInWithUser: User? = nil
    var loggedOutWasCalled = false
}

let pool = Pool<DemoOperation>()

let vc = SomeViewController(pool: pool)

// call this when state changes
let email = "user@example.com"
let password = "password123"

print(vc.loggedInWithUser)
pool.run(.Login(email, password))
print(vc.loggedInWithUser)

print(vc.loggedOutWasCalled)
pool.run(.Logout)
print(vc.loggedOutWasCalled)
