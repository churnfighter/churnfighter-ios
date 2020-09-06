//
//  ChurnFighterTests.swift
//  ChurnFighter
//


import XCTest
@testable import ChurnFighter
import StoreKit

final class ChurnFighterTests: XCTestCase {
    
    private let userDefaults = UserDefaults(suiteName: "churnFighter")
    private var stubBundleProvider: StubBundleProvider!
    private var stubLocaleProvider: StubLocaleProvider!
    private var stubDeviceProvider: StubDeviceProvider!
    private var stubTimeZoneProvider: StubTimeZoneProvider!
    private var stubApiClient: StubApiClient!
    private var stubStoreObserver: StubStoreObserver!
    private var stubPaymentQueue: StubPaymentQueue!
    private var churnFighter: ChurnFighter!
    
    override func setUp() {
        
        super.setUp()
        
        stubBundleProvider = StubBundleProvider(infoDictionary: ["CFBundleShortVersionString": "5.1.3"])
        stubLocaleProvider = StubLocaleProvider(identifier: "localeIdentifier",
                                                    regionCode: "regionCode")
        stubDeviceProvider = StubDeviceProvider(systemVersion: "10.0",
                                                    localizedModel: "iPhone 7",
                                                    identifierForVendor: UUID(uuidString: "3049BAA5-DEC5-408C-9A5B-4728E1E1C890")!)
        stubTimeZoneProvider = StubTimeZoneProvider(identifier: "Europe/Paris")
        stubApiClient = StubApiClient()
        stubStoreObserver = StubStoreObserver()
        stubPaymentQueue = StubPaymentQueue()
        
        churnFighter = ChurnFighter(bundleProvider: stubBundleProvider,
                                    deviceProvider: stubDeviceProvider,
                                    localerProvider: stubLocaleProvider,
                                    timeZoneProvider: stubTimeZoneProvider,
                                    paymentQueue: stubPaymentQueue,
                                    storeObserver: stubStoreObserver,
                                    apiClient: stubApiClient)
        
    }
    
    override func tearDown() {
        
        stubBundleProvider = nil
        stubLocaleProvider = nil
        stubDeviceProvider = nil
        stubTimeZoneProvider = nil
        stubApiClient = nil
        stubStoreObserver = nil
        stubPaymentQueue = nil
        churnFighter = nil
        
        super.tearDown()
    }
    
    // updateSystemValues
    
    func testUpdateSystemValues_currentUserInfoIsNil_returnsCorrectUserInfo() {
        
        let userInfo = churnFighter.updateSystemValues(for: nil)
        
        XCTAssertEqual(userInfo.appVersion, "5.1.3")
        XCTAssertEqual(userInfo.userProperties, [:])
        XCTAssertNil(userInfo.email)
        XCTAssertEqual(userInfo.identifierForVendor, "3049BAA5-DEC5-408C-9A5B-4728E1E1C890")
        XCTAssertEqual(userInfo.iosVersion, "10.0")
        XCTAssertEqual(userInfo.locale, "localeIdentifier")
        XCTAssertEqual(userInfo.model, "iPhone 7")
        XCTAssertNil(userInfo.originalTransactionId)
        XCTAssertNil(userInfo.deviceToken)
        XCTAssertEqual(userInfo.region, "regionCode")
        XCTAssertEqual(userInfo.timeZone, "Europe/Paris")
    }
    
    func testUpdateSystemValues_currentUserInfoIsNoNil_returnsUpdatedUserInfo() {
        
        let previousUserInfo = UserInfo(appVersion: "1.0.3",
                                        userProperties: ["firstName": "John"],
                                        deviceToken: "deviceToken",
                                        email: "john@apple.com",
                                        identifierForVendor: "identifier",
                                        iosVersion: "9.0",
                                        locale: "en-GB",
                                        model: "iPhone 3",
                                        originalTransactionId: "12345",
                                        region: "GB",
                                        timeZone: "Europe/London",
                                        platform:"iOS")
        
        let userInfo = churnFighter.updateSystemValues(for: previousUserInfo)

        //keep previously set values
        XCTAssertEqual(userInfo.userProperties, ["firstName": "John"])
        XCTAssertEqual(userInfo.email, "john@apple.com")
        XCTAssertEqual(userInfo.originalTransactionId, "12345")
        XCTAssertEqual(userInfo.deviceToken, "deviceToken")
        
        //updates system values
        XCTAssertEqual(userInfo.appVersion, "5.1.3")
        XCTAssertEqual(userInfo.identifierForVendor, "3049BAA5-DEC5-408C-9A5B-4728E1E1C890")
        XCTAssertEqual(userInfo.iosVersion, "10.0")
        XCTAssertEqual(userInfo.locale, "localeIdentifier")
        XCTAssertEqual(userInfo.model, "iPhone 7")
        XCTAssertEqual(userInfo.region, "regionCode")
        XCTAssertEqual(userInfo.timeZone, "Europe/Paris")
    }
    
    // init
    
    func testInit_callsAddIAPObserver() {
        
        XCTAssertNotNil(stubStoreObserver.delegate)
        XCTAssertTrue(stubStoreObserver.delegate as AnyObject? === churnFighter)
        XCTAssertTrue(stubPaymentQueue.addCalled)
    }
    
    // cleanup
    
    func testCleanup_RemovesStoreObserver() {
        
        churnFighter.cleanup()
        
        XCTAssertTrue(stubPaymentQueue.removeCalled)
        XCTAssertNil(stubStoreObserver.delegate)
    }
    
    // setUserEmail
    
    func testSetUserEmail() throws {
        
        churnFighter.setUserEmail("john@apple.com")
        let userInfo = try XCTUnwrap(getCurrentUserInfo())
        
        XCTAssertNotNil(userInfo.email)
        XCTAssertEqual(userInfo.email, "john@apple.com")
    }
    
    // setUserProperty
    
    func testSetUserProperty() {
        
        churnFighter.setUserProperty(key: "firstName", value: "John")
        churnFighter.setUserProperty(key: "lastName", value: "Appleseed")
        let userInfo = getCurrentUserInfo()!
        
        XCTAssertEqual(userInfo.userProperties.count, 2)
        XCTAssertEqual(userInfo.userProperties["firstName"], "John")
        XCTAssertEqual(userInfo.userProperties["lastName"], "Appleseed")
    }
    
    // didRegisterForRemoteNotificationsWithDeviceToken
    
    func testDidRegisterForRemoteNotificationsWithDeviceToken() throws {
        
        let deviceTokenData = hexStringToData(hexString: "36d16b69ffbe80f01d8f32c67d62d6d5d7d1bdfecf94e641b7c095ff92ab61dc")!
        churnFighter.didRegisterForRemoteNotificationsWithDeviceToken(deviceTokenData)
        
        let userInfo = getCurrentUserInfo()!
        
        let deviceToken = try XCTUnwrap(userInfo.deviceToken)
        XCTAssertEqual(deviceToken, "36d16b69ffbe80f01d8f32c67d62d6d5d7d1bdfecf94e641b7c095ff92ab61dc")
    }
    
    // actionFromNotificationResponse
    
    func testActionFromNotificationResponse_actionIsAnOffer() throws {
        
        let encodedOfferString = generateOfferEncodedString()
        let userInfo = ["offer": encodedOfferString]
        
        let action = try XCTUnwrap(churnFighter.actionFromNotificationResponse(userInfo: userInfo))
        
        XCTAssertTrue(action is Offer)
        let offer = action as! Offer
        XCTAssertEqual(offer.title, "offerTitle")
        XCTAssertEqual(offer.body, "offerBody")
        XCTAssertEqual(offer.productId, "com.product.id1")
        XCTAssertEqual(offer.offerId, "com.product.offer1")
        XCTAssertEqual(offer.offerType, "subscription")
        XCTAssertEqual(offer.productDescription, "productDescription")
    }
    
    func testActionFromNotificationResponse_actionIsUpdatePaymentDetails() throws {
        
        let encodedUpdatePaymentDetailstring = generateUpdatePaymentDetailsEncodedString()
        let userInfo = ["payment": encodedUpdatePaymentDetailstring]
        
        let action = try XCTUnwrap(churnFighter.actionFromNotificationResponse(userInfo: userInfo))
    
        XCTAssertTrue(action is UpdatePaymentDetails)
        let updatepaymentDetails = action as! UpdatePaymentDetails
        XCTAssertEqual(updatepaymentDetails.title, "title1")
        XCTAssertEqual(updatepaymentDetails.body, "body1")
        XCTAssertEqual(updatepaymentDetails.cta, "Update details")
        XCTAssertEqual(updatepaymentDetails.url, "https://apple.com/updatePaymentDetails")
    }
    
    // actionFromUniversalLink
    
    func testActionFromUniversalLink_actionIsAnOffer() throws {
        
        let encodedOfferString = generateOfferEncodedString()
        let url = URL(string: "https://myapp.com/action?offer=\(encodedOfferString)")
        
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = url
        
        let action = try XCTUnwrap(churnFighter.actionFromUniversalLink(userActivity: userActivity))
        
        XCTAssertTrue(action is Offer)
        let offer = action as! Offer
        XCTAssertEqual(offer.title, "offerTitle")
        XCTAssertEqual(offer.body, "offerBody")
        XCTAssertEqual(offer.productId, "com.product.id1")
        XCTAssertEqual(offer.offerId, "com.product.offer1")
        XCTAssertEqual(offer.offerType, "subscription")
        XCTAssertEqual(offer.productDescription, "productDescription")
    }
    
    func testActionFromUniversalLink_actionIsUpdatePaymentDetails() throws {
        
        let encodedUpdatePaymentDetailsString = generateUpdatePaymentDetailsEncodedString()
        let url = URL(string: "https://myapp.com/action?payment=\(encodedUpdatePaymentDetailsString)")
        
        let userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity.webpageURL = url
        
        let action = try XCTUnwrap(churnFighter.actionFromUniversalLink(userActivity: userActivity))
        
        XCTAssertTrue(action is UpdatePaymentDetails)
        let updatepaymentDetails = action as! UpdatePaymentDetails
        XCTAssertEqual(updatepaymentDetails.title, "title1")
        XCTAssertEqual(updatepaymentDetails.body, "body1")
        XCTAssertEqual(updatepaymentDetails.cta, "Update details")
        XCTAssertEqual(updatepaymentDetails.url, "https://apple.com/updatePaymentDetails")
    }
    
    // prepareOffer
    
    @available(iOS 12.2, *)
    @available(tvOS 12.2, *)
    @available(macOS 10.14.4, *)
    func testPrepareOffer_returnsCorrectPaymentDiscountObject() {
        
        var completion = false
        
        let json = """
                  {
                      "keyIdentifier": "keyIdentifier",
                      "nonce":"3049BAA5-DEC5-408C-9A5B-4728E1E1C890",
                      "signature":"signatureString",
                      "timestamp":1597776685
                  }
              """
        let mockResponse = json.data(using: .utf8)!
        
        let churnFighter = churnFighterWithMockResponse(mockResponse: mockResponse)
        
        churnFighter.prepareOffer(usernameHash: "username",
                                  productIdentifier: "productIdentifier",
                                  offerIdentifier: "offerIdentifier") { (paymentDiscount) in
                                    
                                    XCTAssertEqual(paymentDiscount.identifier, "offerIdentifier")
                                    XCTAssertEqual(paymentDiscount.keyIdentifier, "keyIdentifier")
                                    XCTAssertEqual(paymentDiscount.nonce, UUID(uuidString: "3049BAA5-DEC5-408C-9A5B-4728E1E1C890"))
                                    XCTAssertEqual(paymentDiscount.signature, "signatureString")
                                    XCTAssertEqual(paymentDiscount.timestamp, NSNumber(value: 1597776685))
                                    completion = true
        }
        XCTAssertTrue(completion)
    }
}

private extension ChurnFighterTests {
    
    func getCurrentUserInfo() -> UserInfo? {
        let jsonDecoder = JSONDecoder()
        guard let data = userDefaults?.value(forKey: "userInfo") as? Data,
            let userInfo = try? jsonDecoder.decode(UserInfo.self, from: data) else {
                
                return nil
        }
        return userInfo
    }
    
    func hexStringToData(hexString: String) -> Data? {
        
        if hexString.count % 2 != 0 {
            return nil
        }
        let length = 2
        let end = hexString.count/length
        let range = 0..<end
        let transformHex: (Int) -> String = {
            String(hexString.dropFirst($0 * length).prefix(length))
        }
        
        let transformByte: (String) throws -> UInt8 = {
            guard let value = UInt8($0, radix: 16) else {
                return 0
            }
            return value
        }
        guard let bytes = try? range.map(transformHex).map(transformByte) else {
            
            return nil
        }
        return Data(bytes)
    }
    
    func generateOfferEncodedString() -> String {
        
        let json = ["title": "offerTitle",
                    "body": "offerBody",
                    "productId": "com.product.id1",
                    "offerId": "com.product.offer1",
                    "offerType": "subscription",
                    "productDescription": "productDescription"]
        
        let data = try! JSONEncoder().encode(json)
        return data.base64EncodedString()
    }
    
    func generateUpdatePaymentDetailsEncodedString() -> String {
        
        let json = ["title": "title1",
                    "body": "body1",
                    "cta": "Update details",
                    "url": "https://apple.com/updatePaymentDetails"]
        
        let data = try! JSONEncoder().encode(json)
        
        return data.base64EncodedString()
    }
    
    func churnFighterWithMockResponse(mockResponse: Data) -> ChurnFighter {
        
        let stubHttpClient = StubHttpClient()
        let apiClient = ApiClient(apiKey: "apiKey", httpClient: stubHttpClient)
        let stubBundleProvider = StubBundleProvider(infoDictionary: [:])
        let stubDeviceProvider = StubDeviceProvider(systemVersion: "systemVersion",
                                                    localizedModel: "localizedModel",
                                                    identifierForVendor: UUID())
        let stubLocaleProvider = StubLocaleProvider(identifier: "en-US",
                                                    regionCode: "US")
        let stubTimeZoneProvider = StubTimeZoneProvider(identifier: "America/New-York")
        
        stubHttpClient.setData(data: mockResponse)
        
        return ChurnFighter(bundleProvider: stubBundleProvider,
                            deviceProvider: stubDeviceProvider,
                            localerProvider: stubLocaleProvider,
                            timeZoneProvider: stubTimeZoneProvider,
                            paymentQueue: stubPaymentQueue,
                            storeObserver: stubStoreObserver,
                            apiClient: apiClient)
    }
}
