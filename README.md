![](https://github.com/churnfighter/churnfighter-ios/workflows/UnitTests/badge.svg)
# ChurnFighter iOS framework. 
Swift package for the Churfighter.io platform

## <a name="requirements"></a>Compatibility

- iOS 9.0+
- tvOS 9.0+
- macOS 10.10+

## <a name="usage"></a>Getting started

### Add the swift package to your project

1. Open you project in XCode
2. Select File / Swift Packages / Add Package Dependency ...
3. Enter this repository URL: [https://github.com/churnfighter/churnfighter-ios](https://github.com/churnfighter/churnfighter-ios)
4. Use Version **Up to next Major** 1.0.0 < 2.0.0

### Import the ChurnFighter module

```swift
import ChurnFighter
```

### Configure ChurnFighter in your app delegate

```swift
ChurnFighter.configure(apiKey: "<<apiKey>>", secret: "<<apiSecret>>")
```
Your api Key and Secret can be found in the App Settings on [churnfighter.io](https://churnfighter.io)
### Set the user email if / when available
```swift
ChurnFighter.shared.setUserEmail("user@example.com")
```

### Set the user device token if / when available
```swift
public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    ChurnFighter.shared.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
}
```
### Set custom user properties
```swift
ChurnFighter.shared.setUserProperty(key: "firstName", value: "John")
ChurnFighter.shared.setUserProperty(key: "lastName", value: "Appleseed")
```
### React to receiving a push notification from ChurnFighter
```swift
public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    let userInfo = response.notification.request.content.userInfo

    guard let action = ChurnFighter.shared.actionFromNotificationResponse(userInfo: userInfo) else {
    completionHandler()
    return
    }
        
    if let offer = action as? Offer {

        displayOffer(offer)
    }
        
    if let updatePaymentDetails = action as? UpdatePaymentDetails {

        displayUpdatePaymentDetails(updatePaymentDetails)
    }
    
    completionHandler()
}
```
### React to opening the app from a universal link
```swift
public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
    guard let action = ChurnFighter.shared.actionFromUniversalLink(userActivity: userActivity) else {

        return true
    }
    
    if let offer = action as? Offer {

        displayOffer(offer)
    }
        
    if let updatePaymentDetails = action as? UpdatePaymentDetails {

        displayUpdatePaymentDetails(updatePaymentDetails)
    }
    
    return true
}
```
### Generate a SKPaymentDiscount for a subscription offer
```swift
ChurnFighter.shared.prepareOffer(usernameHash: userNameHash,
                                 productIdentifier: offer.productId,
                                 offerIdentifier: offer.offerId) { (paymentDiscount) in
    
    if let paymentDiscount = paymentDiscount {

        displaySubscriptionOffer(paymentDiscount)
    }
}
```

## <a name="author"></a>Author

ChurnFighter.io 


## <a name="license"></a>License

ChurnFighter is available under the MIT license. See the LICENSE file for more info.
