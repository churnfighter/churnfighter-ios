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

Swift 

```swift
import ChurnFighter
```
Objective C

```swift
@import ChurnFighter;
```


### Configure ChurnFighter in your app delegate
Swift

```swift
ChurnFighter.configure(apiKey: "<<apiKey>>", secret: "<<apiSecret>>")
```
Objective C

```objc
[ChurnFighter configureWithApiKey:@"<<apiKey>>" secret:@"<<apiSecret>>"];
```

Your api Key and Secret can be found in the App Settings on [churnfighter.io](https://churnfighter.io)
### Set the user email if / when available
Swift

```swift
ChurnFighter.shared.setUserEmail("user@example.com")
```
Objective C

```objc
[ChurnFighter.shared setUserEmail:@"user@example.com"];
```

### Set the user device token if / when available
Swift

```swift
public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    ChurnFighter.shared.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
}
```
Objective C

```objc
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [ChurnFighter.shared didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
```
### Set custom user properties
Swift

```swift
ChurnFighter.shared.setUserProperty(key: "firstName", value: "John")
ChurnFighter.shared.setUserProperty(key: "lastName", value: "Appleseed")
```

Objective C

```swift
[ChurnFighter.shared setUserPropertyWithKey:@"firstName" value:@"John"];
[ChurnFighter.shared setUserPropertyWithKey:@"firstName" value:@"Appleseed"];
```

### React to receiving a push notification from ChurnFighter
Swift

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
Objective C

```objc
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSObject<ActionProtocol> * action = [ChurnFighter.shared actionFromNotificationResponseWithUserInfo:userInfo];

    if (action != NULL && [action isKindOfClass:[Offer class]]) {

        Offer *offer = (Offer *) action ;
        [self displayOffer: offer];
    }
    
    if (action != NULL && [action isKindOfClass:[UpdatePaymentDetails class]]) {

        UpdatePaymentDetails *updatePaymentDetails = (UpdatePaymentDetails *) action ;
        [self displayUpdatePaymentDetails: updatePaymentDetails];
    }
    
    completionHandler()
}
```
### React to opening the app from a universal link
Swift

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

Objective C

```
- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    
    NSObject<ActionProtocol> * action = [ChurnFighter.shared actionFromUniversalLinkWithUserActivity:userActivity];
    
    if ([action isKindOfClass:[Offer class]]) {
           
        Offer *offer = (Offer *) action ;
        [self displayOffer: offer];
    }
    
    if ([action isKindOfClass:[UpdatePaymentDetails class]]) {
       
        UpdatePaymentDetails *updatePaymentDetails = (UpdatePaymentDetails *) action ;
        [self displayUpdatePaymentDetails: updatePaymentDetails];
    }
    
    return true;
}
```

### Generate a SKPaymentDiscount for a subscription offer
Swift

```swift
ChurnFighter.shared.prepareOffer(usernameHash: userNameHash,
                                 productIdentifier: offer.productId,
                                 offerIdentifier: offer.offerId) { (paymentDiscount) in
    
    if let paymentDiscount = paymentDiscount {

        displaySubscriptionOffer(paymentDiscount)
    }
}
```
Objective C

```
if (action != NULL && [action isKindOfClass:[Offer class]]) {

    Offer *offer = (Offer *) action ;
    
    
    if (@available(iOS 12.2, *)) {
        
        [ChurnFighter.shared prepareOfferWithUsernameHash:@"userNameHash"
                                        productIdentifier:@"productIdentifier"
                                          offerIdentifier:@"offerIdentifier"
                                               completion:^(SKPaymentDiscount * _Nonnull paymentDiscount) {
            
            [self processOfferWithDiscount:paymentDiscount];
        }];
    }
}
```

## <a name="author"></a>Author

ChurnFighter.io 


## <a name="license"></a>License

ChurnFighter is available under the MIT license. See the LICENSE file for more info.
