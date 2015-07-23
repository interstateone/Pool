import Foundation

public protocol PoolOperation {
    typealias NotificationManager: PoolNotificationManager

    func operation(notificationManager: NotificationManager) -> NSOperation
    func descendantOperations() -> NSOperation // actually a Pipeline
}

public protocol PoolNotificationManager {
    typealias Notification
    init()
    func notify(notification: Notification)
}

public final class Pool<O where O: PoolOperation> {
    public let notificationManager = O.NotificationManager()

    public init() {}

    public func run(operation: O) {
        let rootOperation = operation.operation(notificationManager)
        let descendant = operation.descendantOperations()
        descendant.addDependency(rootOperation)

        let q = NSOperationQueue()
        q.addOperation(rootOperation)
        q.addOperation(descendant)
    }
}

public protocol OperationObserver: class {
    typealias Operation: PoolOperation
    var pool: Pool<Operation> { get set }
    func registerForNotifications()
}

public extension OperationObserver {
    func registerForNotifications() {
        assertionFailure("registerForNotifications must be overridden by inheriting protocol")
    }
}

// example

public class OutputOperation<T>: NSBlockOperation {
    public var output: T?
}
