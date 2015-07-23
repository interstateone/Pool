import Foundation
import UIKit

// pretend with me
class SomeViewController: NSObject, DemoOperationObserver {

    // MARK: OperationObserver

    typealias NotificationManager = DemoPoolNotificationManager

    var pool: Pool<NotificationManager>

    // MARK: DemoOperationObserver

    func loggedIn() {
        // Run some operations
        loggedInWasCalled = true
    }

    func loggedOut() {
        // Run some others
        loggedOutWasCalled = true
    }

    // MARK: -

    init(pool: Pool<NotificationManager>) {
        self.pool = pool
        super.init()
        registerForNotifications()
    }

    // MARK: Example

    var loggedInWasCalled = false
    var loggedOutWasCalled = false
}

let pool = Pool<DemoPoolNotificationManager>()

let vc = SomeViewController(pool: pool)

// call this when state changes
let email = "user@example.com"
let password = "password123"

print(vc.loggedInWasCalled)
pool.run(.Login(email, password))
print(vc.loggedInWasCalled)

print(vc.loggedOutWasCalled)
pool.run(.Logout)
print(vc.loggedOutWasCalled)
