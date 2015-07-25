# Pool

**This is a work-in-progress and might not ever be any more than an experiment.**

A pool runs predefined [Pipelines](https://github.com/interstateone/Pipeline) and notifies observers with the result.

## A Trivial Example

```swift
let pool = Pool<DemoOperation>()

let vc = DemoViewController(pool: pool)

let email = "user@example.com"
let password = "password123"

XCTAssertNil(vc.loggedInUser)
pool.run(.Login(email, password))
XCTAssertNotNil(vc.loggedInUser)

XCTAssertFalse(vc.loggedOutWasCalled)
pool.run(.Logout)
XCTAssertTrue(vc.loggedOutWasCalled)
```
