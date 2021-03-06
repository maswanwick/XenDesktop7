
## XD7StoreFrontSessionStateTimeout

Sets the sessionState time interval for a Web Receiver site

### Syntax

```
XD7StoreFrontSessionStateTimeout [string]
{
    StoreName = [String]
    [ IntervalInMinutes = [UInt32] ]
    [ CommunicationAttempts = [UInt32] ]
    [ CommunicationTimeout = [UInt32] ]
    [ LoginFormTimeout = [UInt32] ]
}
```

### Properties

* **StoreName**: StoreFront store name.
* **IntervalInMinutes**: Time interval in minutes.
* **CommunicationAttempts**: Communication attempts.
* **CommunicationTimeout**: Communication timeout.
* **LoginFormTimeout**: Login form timeout.

### Configuration

```
Configuration XD7Example {
    Import-DscResource -ModuleName XenDesktop7
    XD7StoreFrontSessionStateTimeout XD7StoreFrontSessionStateTimeoutExample {
        StoreName = 'mock'
        IntervalInMinutes = 20
    }
}
```
