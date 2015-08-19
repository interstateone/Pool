import Foundation
import Pipeline

public protocol PoolOperation {
    typealias Notification
    typealias OperationResult

    var pipeline: Pipeline<OperationResult> { get }
    func notification(value: OperationResult) -> Notification
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
        operation.pipeline.success { result in
            let notification = operation.notification(result)
            self.notificationManager.notify(notification)
        }.start()
    }
}

public protocol OperationObserver: class {
    typealias NotificationManager: PoolNotificationManager

    var notificationManager: NotificationManager { get }
    func registerForNotifications()
}
