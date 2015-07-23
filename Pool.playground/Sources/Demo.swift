import Foundation

public enum DemoOperationsNotification {
    case LoggedIn
    case LoggedOut
}

public final class User {}

public final class DemoPoolNotificationManager: PoolNotificationManager {
    public typealias Operation = DemoOperation
    
    public init() {}

    var loggedInObservers = ObserverSet<Void>()
    var loggedOutObservers = ObserverSet<Void>()

    public func notify(notification: Operation.Notification) {
        switch notification {
        case .LoggedIn:
            loggedInObservers.notify()
        case .LoggedOut:
            loggedOutObservers.notify()
        }
    }
}

public enum DemoOperation: PoolOperation {
    public typealias Notification = DemoOperationsNotification

    case Login(String, String)
    case Logout

    public func operation() -> NSOperation {
        switch self {
        case .Login(let email, let password):
            let op = OutputOperation<User> {
                print("logging in with \(email), \(password)")
            }
            op.output = User()
            return op
        case .Logout:
            let op = OutputOperation<Void> {
                print("logging out")
            }
            op.output = ()
            return op
        }
    }

    // again, would actually be a pipeline
    public func descendantOperations() -> NSOperation {
        switch self {
        case .Login:
            return NSBlockOperation {
                // load user info, update views, etc.
            }
        case .Logout:
            return NSBlockOperation {
                // purge caches, update views, etc.
            }
        }
    }

    public func notification() -> DemoOperationsNotification {
        switch self {
        case .Login(_, _): return .LoggedIn
        case .Logout: return .LoggedOut
        }
    }
}

public protocol DemoOperationObserver: OperationObserver {
    typealias NotificationManager = DemoPoolNotificationManager

    func loggedIn()
    func loggedOut()
}

public extension DemoOperationObserver where NotificationManager: DemoPoolNotificationManager {
    func registerForNotifications() {
        self.pool.notificationManager.loggedInObservers.add(self, self.dynamicType.loggedIn)
        self.pool.notificationManager.loggedOutObservers.add(self, self.dynamicType.loggedOut)
    }
}
