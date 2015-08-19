# Pool

**This is a work-in-progress and might not ever be any more than an experiment.**

A pool runs predefined operations with [Pipeline](https://github.com/interstateone/Pipeline) and notifies observers with the result.

## A Trivial Example

```swift
let pool = Pool<DemoPoolNotificationManager>()
let viewController = DemoViewController(notificationManager: pool.notificationManager)

pool.run(LoginOperation(email: "user@example.com", password: "password123"))
print(viewController.loggedInUser) // <User: 0x7fe4d9f315b0>

pool.run(LogoutOperation())
print(viewController.loggedOutWasCalled) // true
```

