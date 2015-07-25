import Foundation

public protocol PoolOperation {
    typealias NotificationManager: PoolNotificationManager

    func operation(notificationManager: NotificationManager) -> NSOperation // Pipelinable
    func descendantOperations() -> NSOperation // takes a Pipeline, returns a Pipeline
    func notification<Value>(value: Value) -> NotificationManager.Notification?
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
        // Pipeline {
        //     rootOperation
        // }
        // .success { result in
        //     if let notification = operation.notification(result) {
        //         notificationManager.notify(notification)
        //     }
        //     return result
        // }
        let descendant = operation.descendantOperations()
        descendant.addDependency(rootOperation)
        // rootPipeline = operation.appendDescendantOperations(rootPipeline)

        let q = NSOperationQueue()
        q.addOperation(rootOperation)
        q.addOperation(descendant)
        // rootPipeline.start()
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
