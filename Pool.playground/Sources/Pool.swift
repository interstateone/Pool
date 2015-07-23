import Foundation

public protocol PoolOperation {
    typealias Notification
    func operation() -> NSOperation
    func descendantOperations() -> NSOperation // actually a Pipeline
    func notification() -> Notification
}

public protocol PoolNotificationManager {
    typealias Operation: PoolOperation
    init()
    func notify(notification: Operation.Notification)
}

public final class Pool<N: PoolNotificationManager> {
    public let notificationManager = N()

    public init() {}

    public func run(operation: N.Operation) {
        let rootOperation = operation.operation()
        let descendant = operation.descendantOperations()
        descendant.addDependency(rootOperation)
        // Pipeline should have a way to "prepend" preceding operations
        // Enqueue both

        // pipeline.then {
        notificationManager.notify(operation.notification())
        // }
    }
}

public protocol OperationObserver: class {
    typealias NotificationManager: PoolNotificationManager

    var pool: Pool<NotificationManager> { get set }

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
