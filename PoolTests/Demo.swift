import Foundation
import Pool
import Pipeline

public final class User {
    let email: String
    let password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public enum DemoOperationsNotification {
    case LoggedIn(User)
    case LoggedOut
}

public final class DemoPoolNotificationManager: PoolNotificationManager {
    public typealias Notification = DemoOperationsNotification
    
    public init() {}

    var loggedInObservers = ObserverSet<User>()
    var loggedOutObservers = ObserverSet<Void>()

    public func notify(notification: Notification) {
        switch notification {
        case let .LoggedIn(user):
            loggedInObservers.notify(user)
        case .LoggedOut:
            loggedOutObservers.notify()
        }
    }
}

public struct LoginOperation: PoolOperation {
    public typealias Notification = DemoOperationsNotification
    public typealias OperationResult = User

    let email: String
    let password: String

    public var pipeline: Pipeline<OperationResult> {
        return Pipeline(.Default) {
            PipelineOperation { fulfill, reject, handlers in
                print("logging in with \(self.email), \(self.password)")
                fulfill(User(email: self.email, password: self.password))
            }
        }
    }

    public func notification(value: OperationResult) -> Notification {
        return .LoggedIn(value)
    }
}

public struct LogoutOperation: PoolOperation {
    public typealias Notification = DemoOperationsNotification
    public typealias OperationResult = Void

    public var pipeline: Pipeline<OperationResult> {
        return Pipeline(.Default) {
            PipelineOperation { fulfill, reject, handlers in
                print("logging out")
                fulfill()
            }
        }
    }

    public func notification(value: OperationResult) -> Notification {
        return .LoggedOut
    }
}

public protocol DemoOperationObserver: OperationObserver {
    func loggedInWithUser(user: User)
    func loggedOut()
}

public extension DemoOperationObserver where NotificationManager == DemoPoolNotificationManager {
    func registerForNotifications() {
        self.notificationManager.loggedInObservers.add(self, self.dynamicType.loggedInWithUser)
        self.notificationManager.loggedOutObservers.add(self, self.dynamicType.loggedOut)
    }
}

class DemoViewController: NSObject, DemoOperationObserver {

    // MARK: OperationObserver

    typealias NotificationManager = DemoPoolNotificationManager

    let notificationManager: NotificationManager

    // MARK: DemoOperationObserver

    func loggedInWithUser(user: User) {
        // Run some operations
        loggedInUser = user
        print("login observed")
    }

    func loggedOut() {
        // Run some others
        loggedOutWasCalled = true
        print("logout observed")
    }

    // MARK: -

    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
        super.init()
        registerForNotifications()
    }

    // MARK: Example mocks

    var loggedInUser: User? = nil
    var loggedOutWasCalled = false
}
