import Foundation
import Pipeline

public protocol PoolOperation {
    typealias Notification
    typealias OperationValue

    var pipeline: Pipeline<OperationValue> { get }
    func notification(value: OperationValue) -> Notification?
}

public protocol PoolNotificationManager {
    typealias Notification
    init()
    func notify(notification: Notification)
}

public final class Pool<NotificationManager where NotificationManager: PoolNotificationManager> {
    public let notificationManager = NotificationManager()

    public init() {}

    public func run<Operation: PoolOperation where Operation.Notification == NotificationManager.Notification>(operation: Operation) {
        var pipeline = operation.pipeline
        pipeline = pipeline.success { (result: Operation.OperationValue) -> Operation.OperationValue in
            if let notification = operation.notification(result) {
                self.notificationManager.notify(notification)
            }
            return result
        }
        pipeline.start()
    }
}

public protocol OperationObserver: class {
    typealias NotificationManager: PoolNotificationManager

    var notificationManager: NotificationManager { get }
    func registerForNotifications()
}
