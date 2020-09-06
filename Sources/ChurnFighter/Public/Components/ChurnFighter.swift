//
//  ChurnFighter.swift
//  ChurnFighter
//


import Foundation
import StoreKit

#if os(macOS)
#else
import UIKit
#endif

@objc
final public class ChurnFighter: NSObject, ChurnFighterDelegate {
    
    static private var privateShared: ChurnFighter? = nil
    
    private let actionTypeOffer = "offer"
    private let actionTypeUpdatePaymentDetails = "payment"
    
    private var apiClient: ApiClientProtocol
    private let bundleProvider: BundleProviding
    private let deviceProvider: DeviceProviding
    private let localeProvider: LocaleProviding
    private let receiptHashKey = "receiptHash"
    private var storeObserver: StoreObserverProtocol
    private let throttler = Throttler(seconds: 5)
    private let timeZoneProvider: TimeZoneProviding
    private let userDefaults = UserDefaults(suiteName: "churnFighter")
    private let paymentQueue: PaymentQueueProtocol
    
    @objc
    public static let shared: ChurnFighter = {
        
        guard let privateShared = privateShared else {
            
            assertionFailure("ChurnFighter framework has not been configured")
            return ChurnFighter(apiKey: "", secret: "")
        }
        return privateShared
    }()
    
    private var userInfo: UserInfo {
        get {
            return updateSystemValues(for: UserInfo.loadFromUserDefaults(userDefaults: userDefaults))
        }
        set {
            if (newValue != userInfo) {
                newValue.saveToUserDefaults(userDefaults: userDefaults)
                synchroniseUserInfo()
            }
        }
    }
    
    
    private convenience init(apiKey: String, secret: String) {
        
        #if os(macOS)
        let deviceProvider = MacDeviceProvider()
        #else
        let deviceProvider = UIDevice.current
        #endif
        
        self.init(bundleProvider: Bundle.main,
                  deviceProvider: deviceProvider,
                  localerProvider: Locale.current,
                  timeZoneProvider: TimeZone.current,
                  paymentQueue:  SKPaymentQueue.default(),
                  storeObserver: StoreObserver(),
                  apiClient: ApiClient(apiKey: apiKey, secret: secret))
    }
    
    internal init(bundleProvider: BundleProviding,
                  deviceProvider: DeviceProviding,
                  localerProvider: LocaleProviding,
                  timeZoneProvider: TimeZoneProviding,
                  paymentQueue: PaymentQueueProtocol,
                  storeObserver: StoreObserverProtocol,
                  apiClient: ApiClientProtocol) {
        
        self.bundleProvider = bundleProvider
        self.deviceProvider = deviceProvider
        self.localeProvider = localerProvider
        self.timeZoneProvider = timeZoneProvider
        self.storeObserver = storeObserver
        self.paymentQueue = paymentQueue
        self.apiClient = apiClient
        
        super.init()
        
        addIAPObserver()
        loadReceipt()
    }
}

public extension ChurnFighter {
    
    @objc
    static func configure(apiKey: String, secret: String) {

        privateShared = ChurnFighter(apiKey: apiKey, secret: secret)
    }
    
    @objc
    func cleanup() {
        
        removeIAPObserver()
    }
    
    @objc
    func setUserEmail(_ email: String) {
        
        userInfo.set(email: email)
    }
    
    
    @objc
    func setUserProperty(key: String, value: String) {
        
        userInfo.set(userProperty: [key: value])
    }
    
    @objc
    func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        userInfo.set(deviceToken: deviceTokenString)
    }
    
    @objc
    func actionFromNotificationResponse(userInfo: [AnyHashable: Any]) -> ActionProtocol? {
        
        if let encodedOffer = userInfo[actionTypeOffer] as? String,
            let offer = decodeOffer(encodedOffer: encodedOffer)  {
            
            return offer
        }
        
        if let encodedUpdatePaymentDetails = userInfo[actionTypeUpdatePaymentDetails] as? String,
            let updatePaymentDetails = decodeUpdatePaymentDetails(encodedUpdatepaymentDetails: encodedUpdatePaymentDetails) {
            
            return updatePaymentDetails
        }
        
        return nil
    }
    
    @objc
    func actionFromUniversalLink(userActivity: NSUserActivity) -> ActionProtocol? {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let params = components.queryItems else {
                
                return nil
        }
        
        if let offer = params.first(where: {$0.name == actionTypeOffer}),
            let encodedOffer = offer.value,
            let decodedOffer = decodeOffer(encodedOffer: encodedOffer) {
            
            return decodedOffer
        }
        
        if let updatePaymentDetails = params.first(where: {$0.name == actionTypeUpdatePaymentDetails}),
            let encodedUpdatePaymentDetails = updatePaymentDetails.value,
            let decodedUpdatePaymentDetails = decodeUpdatePaymentDetails(encodedUpdatepaymentDetails: encodedUpdatePaymentDetails) {
            
            return decodedUpdatePaymentDetails
        }
        
        return nil
    }
    
    @available(iOS 12.2, *)
    @available(tvOS 12.2, *)
    @available(macOS 10.14.4, *)
    @objc
    func prepareOffer(usernameHash: String, productIdentifier: String, offerIdentifier: String, completion: @escaping(SKPaymentDiscount) -> Void) {
        
        apiClient.subscriptionOfferSignature(offerIdentifier: offerIdentifier,
                                             productIdentifier: productIdentifier,
                                             usernameHash: usernameHash) { (keyIdentifier, nonce, signature, timestamp) in
                                                
                                                
                                                let discountOffer = SKPaymentDiscount(identifier: offerIdentifier,
                                                                                      keyIdentifier: keyIdentifier,
                                                                                      nonce: nonce,
                                                                                      signature: signature,
                                                                                      timestamp: NSNumber(value: timestamp))
                                                completion(discountOffer)
        }
    }
    
}

private extension ChurnFighter {
    
    func synchroniseUserInfo() {
        
        throttler.throttle {
            
            self.apiClient.uploadUserInfo(userInfo: self.userInfo) { (_) in
            }
        }
    }
    
    func addIAPObserver() {
        
        storeObserver.delegate = self
        paymentQueue.add(storeObserver)
    }
    
    func removeIAPObserver() {
        
        storeObserver.delegate = nil
        paymentQueue.remove(storeObserver)
    }
    
    func getReceiptHash(receipt: String) -> Int {
        
        var hash = Hasher()
        hash.combine(receipt)
        return hash.finalize()
    }
    
    func receiptString() -> String? {
        
        guard
            let receiptUrl = bundleProvider.appStoreReceiptURL,
            let receiptData = try? Data(contentsOf: receiptUrl, options: .alwaysMapped) else { return nil }
        
        return receiptData.base64EncodedString()
    }
    
    func decodeOffer(encodedOffer: String) -> Offer? {
        
        guard let data = Data(base64Encoded: encodedOffer),
            let offer =  try? JSONDecoder().decode(Offer.self, from: data)
            else { return nil }
        
        return offer
    }
    
    func decodeUpdatePaymentDetails(encodedUpdatepaymentDetails: String) -> UpdatePaymentDetails? {
        
        guard let data = Data(base64Encoded: encodedUpdatepaymentDetails),
            let updatePaymentDetails =  try? JSONDecoder().decode(UpdatePaymentDetails.self, from: data)
            else { return nil }
        
        return updatePaymentDetails
    }
}


extension ChurnFighter {
        
    func setOriginalTransactionId(originalTransactionId: String) {
        
        userInfo.set(originalTransactionId: originalTransactionId)
    }
    
    
    func loadReceipt() {
        
        guard let deviceReceiptString = receiptString() else {
            
            return
        }
        let receiptHash = getReceiptHash(receipt: deviceReceiptString)
        
        if let previousReceiptHash = userDefaults?.integer(forKey: receiptHashKey),
            previousReceiptHash == receiptHash {
            
            return
        }
        
        apiClient.uploadReceipt(receipt: deviceReceiptString, userInfo: userInfo) { (success) in
            
            if success {
                self.userDefaults?.setValue(receiptHash, forKey: self.receiptHashKey)
            }
        }
    }
    
    
    func updateSystemValues(for userInfo: UserInfo?) -> UserInfo {
        
        let userLocaleIdentifier = localeProvider.identifier
        let region = localeProvider.regionCode
        let appVersion = bundleProvider.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let iosVersion = deviceProvider.systemVersion
        let model = deviceProvider.localizedModel
        
        var identifierForVendor = UUID().uuidString
        if let deviceIdentifier = deviceProvider.identifierForVendor {
            identifierForVendor = deviceIdentifier.uuidString
        }
        
        let timeZone = timeZoneProvider.identifier
        
        #if os(iOS)
        let platform = "iOS"
        #elseif os(tvOS)
        let platform = "tvOS"
        #elseif os(OSX)
        let platform = "macOS"
        #else
        let platform = "unknown"
        #endif
        
        return UserInfo(appVersion: appVersion,
                        userProperties: userInfo?.userProperties ?? [:],
                        deviceToken: userInfo?.deviceToken,
                        email: userInfo?.email,
                        identifierForVendor: identifierForVendor,
                        iosVersion: iosVersion,
                        locale: userLocaleIdentifier,
                        model: model,
                        originalTransactionId: userInfo?.originalTransactionId,
                        region: region,
                        timeZone: timeZone,
                        platform: platform)
    }
}
