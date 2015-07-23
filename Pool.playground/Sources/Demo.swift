import Foundation

public enum DemoOperationsNotification {
    case LoggedIn(User)
    case LoggedOut
}

public final class User {}

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

public enum DemoOperation: PoolOperation {
    case Login(String, String)
    case Logout

    public typealias NotificationManager = DemoPoolNotificationManager
    public func operation(notificationManager: NotificationManager) -> NSOperation {
        switch self {
        case .Login(let email, let password):
            let op = OutputOperation<User> {
                print("logging in with \(email), \(password)")
            }
            op.output = User()

            if let output = op.output {
                notificationManager.notify(.LoggedIn(output))
            }
            
            return op
        case .Logout:
            let op = OutputOperation<Void> {
                print("logging out")
            }
            op.output = ()

            notificationManager.notify(.LoggedOut)

            return op
        }
    }

    // again, would actually be a pipeline
    public func descendantOperations() -> NSOperation {
        switch self {
        case .Login:
            return NSBlockOperation {
                // load user info, update views, etc.
                print("login descendant")
            }
        case .Logout:
            return NSBlockOperation {
                // purge caches, update views, etc.
                print("logout descendant")
            }
        }
    }
}

public protocol DemoOperationObserver: OperationObserver {
    typealias Operation = DemoOperation

    func loggedInWithUser(user: User)
    func loggedOut()
}

public extension DemoOperationObserver where Operation == DemoOperation {
    func registerForNotifications() {
        self.pool.notificationManager.loggedInObservers.add(self, self.dynamicType.loggedInWithUser)
        self.pool.notificationManager.loggedOutObservers.add(self, self.dynamicType.loggedOut)
    }
}
