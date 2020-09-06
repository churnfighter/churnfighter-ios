//
//  ApiClientTests.swift
//  ChurnFighterTests
//


import XCTest
@testable import ChurnFighter

final class ApiClientTests: XCTestCase {
    
    private var apiClient: ApiClient!
    private var stubHttpClient: StubHttpClient!
    
    override func setUp() {
        super.setUp()
        
        stubHttpClient = StubHttpClient()
        apiClient = ApiClient(apiKey: "apiKey", httpClient: stubHttpClient)
    }
    
    override func tearDown() {
        
        stubHttpClient = nil
        apiClient = nil
        super.tearDown()
    }
    
    // uploadUserInfo
    
    func testUploadUserInfo_noEmail_noDeviceToken_doesNotUpload() {
        
        let userInfo = generateUserInfo(deviceToken: nil, email: nil)
        
        apiClient.uploadUserInfo(userInfo: userInfo) { (_) in
        }
        XCTAssertFalse(stubHttpClient.postCalled)
    }
    
    func testUploadUserInfo_email_noDeviceToken_uploadsUserInfo() {
        
        let userInfo = generateUserInfo(deviceToken: nil, email: "test@example.com")
        
        apiClient.uploadUserInfo(userInfo: userInfo) { (_) in
        }
        XCTAssertTrue(stubHttpClient.postCalled)
    }
    
    func testUploadUserInfo_noEmail_deviceToken_uploadsUserInfo() {
        
        let userInfo = generateUserInfo(deviceToken: "token", email: nil)
        
        apiClient.uploadUserInfo(userInfo: userInfo) { (_) in
        }
        XCTAssertTrue(stubHttpClient.postCalled)
    }
    
    func testUploadUserInfo_emailAnddeviceToken_uploadsUserInfo() {
        
        let userInfo = generateUserInfo(deviceToken: "token", email: "test@example.com")
        
        apiClient.uploadUserInfo(userInfo: userInfo) { (_) in
        }
        XCTAssertTrue(stubHttpClient.postCalled)
    }
    
    func testUploadUserInfo_endPointCorrect() throws {
        
        let userInfo = generateUserInfo(email: "test@example.com")
        apiClient.uploadUserInfo(userInfo: userInfo) { (_) in
        }
        
        let url = try XCTUnwrap(stubHttpClient.url)
        XCTAssertEqual(url, URL(string: "https://api.churnfighter.io/user/apiKey"))
    }
    
    func testUploadUserInfo_jsonDataPostedCorrect() throws {
        
        let userInfo = generateUserInfo(email: "test@example.com")
        apiClient.uploadUserInfo(userInfo: userInfo) { (_) in
        }
        
        let jsonData = try XCTUnwrap(JSONEncoder().encode(userInfo))
        
        XCTAssertEqual(stubHttpClient.jsonData, jsonData)
    }
    
    // uploadReceipt
    
    func testUploadReceipt_noEmail_noDeviceToken_doesNotUploadReceipt() {
    
        let userInfo = generateUserInfo(deviceToken: nil, email: nil)
        apiClient.uploadReceipt(receipt: "receipt string", userInfo: userInfo) { (_) in
        }
        
        XCTAssertFalse(stubHttpClient.postCalled)
    }
    
    func testUploadReceipt_email_noDeviceToken_uploadsReceipt() {
    
        let userInfo = generateUserInfo(deviceToken: nil, email: "test@example.com")
        apiClient.uploadReceipt(receipt: "receipt string", userInfo: userInfo) { (_) in
        }
        
        XCTAssertTrue(stubHttpClient.postCalled)
    }
    
    func testUploadReceipt_noEmail_deviceToken_uploadsReceipt() {
    
        let userInfo = generateUserInfo(deviceToken: "token", email: nil)
        apiClient.uploadReceipt(receipt: "receipt string", userInfo: userInfo) { (_) in
        }
        
        XCTAssertTrue(stubHttpClient.postCalled)
    }
    
    func testUploadReceipt_email_deviceToken_uploadsReceipt() {
    
        let userInfo = generateUserInfo(deviceToken: "token", email: "test@example.com")
        apiClient.uploadReceipt(receipt: "receipt string", userInfo: userInfo) { (_) in
        }
        
        XCTAssertTrue(stubHttpClient.postCalled)
    }
    
    
    
    func testUploadReceipt_endPointCorrect() throws {
        
        let userInfo = generateUserInfo(email:"test@example.com")
        apiClient.uploadReceipt(receipt: "receipt string", userInfo: userInfo) { (_) in
            
        }
        
        let url = try XCTUnwrap(stubHttpClient.url)
        XCTAssertEqual(url, URL(string: "https://api.churnfighter.io/receipt/ios/apiKey/vendorIdentifier"))
    }
    
    func testUploadReceipt_jsonDataCorrect() throws {
        
        let userInfo = generateUserInfo(email:"test@example.com")
        apiClient.uploadReceipt(receipt: "receipt string", userInfo: userInfo) { (_) in
            
        }
        
        let expectedJSONData = try XCTUnwrap(JSONEncoder().encode(["receipt": "receipt string"]))
        
        XCTAssertEqual(stubHttpClient.jsonData,expectedJSONData)
    }
    
    func testUploadReceipt_errorOccurs_returnsErrorInCompletion() {
        
        stubHttpClient.setError(isError: true)
        
        let userInfo = generateUserInfo(email:"test@example.com")
        
        var completion = false
        apiClient.uploadReceipt(receipt: "receipt string", userInfo: userInfo) { (success) in
            XCTAssertFalse(success)
            completion = true
        }
        XCTAssertTrue(completion)
    }
    
    func testUploadReceipt_noErrorOccurs_returnsSuccessInCompletion() {
        
        stubHttpClient.setError(isError: false)
        
        let userInfo = generateUserInfo(email:"test@example.com")
        
        var completion = false
        apiClient.uploadReceipt(receipt: "receipt string", userInfo: userInfo) { (success) in
            XCTAssertTrue(success)
            completion = true
        }
        XCTAssertTrue(completion)
    }
    
    // subscriptionOfferSignature
    
    func testSubscriptionOfferSignature_endPointCorrect() throws {
        
        let jsonData = offerSignatureResponse()
        stubHttpClient.setData(data: jsonData)
        apiClient.subscriptionOfferSignature(offerIdentifier: "offerIdentifier",
                                             productIdentifier: "productIdentifier",
                                             usernameHash: "username") { (_, _, _, _) in
        }
        
        let url = try XCTUnwrap(stubHttpClient.url)
        XCTAssertEqual(url, URL(string: "https://api.churnfighter.io/subscriptionOfferSignature/apiKey"))
    }
    
    func testSubscriptionOfferSignature_jsonDataPostedIsCorrect() throws {
        
        let jsonData = offerSignatureResponse()
        stubHttpClient.setData(data: jsonData)
        apiClient.subscriptionOfferSignature(offerIdentifier: "offerIdentifier",
                                             productIdentifier: "productIdentifier",
                                             usernameHash: "username") { (_, _, _, _) in
        }
        
        
        let data = try XCTUnwrap(stubHttpClient.jsonData)
        
        let postedJSONObject = try! JSONDecoder().decode([String: String].self, from: data)
        
        XCTAssertEqual(postedJSONObject["applicationUsername"], "username")
        XCTAssertEqual(postedJSONObject["productIdentifier"], "productIdentifier")
        XCTAssertEqual(postedJSONObject["offerIdentifier"], "offerIdentifier")
    }
    
    func testSubscriptionOfferSignature_callsCompletionWithCorrectData() {
        
        let jsonData = offerSignatureResponse()
        stubHttpClient.setData(data: jsonData)
        var completion = false
        apiClient.subscriptionOfferSignature(offerIdentifier: "offerIdentifier",
                                             productIdentifier: "productIdentifier",
                                             usernameHash: "username") { (keyIdentifier, nonce, signature, timestamp) in
                                                
                                                XCTAssertEqual(keyIdentifier, "keyIdentifier")
                                                XCTAssertEqual(nonce, UUID(uuidString: "3049BAA5-DEC5-408C-9A5B-4728E1E1C890")!)
                                                XCTAssertEqual(signature, "signatureString")
                                                XCTAssertEqual(timestamp, 1597776685)
                                                completion = true
        }
        XCTAssertTrue(completion)
    }
}


private extension ApiClientTests {
    
    func generateUserInfo(appVersion: String? = nil,
                          userProperty: [String:String]? = nil,
                          deviceToken: String? = nil,
                          email: String? = nil,
                          identifierForVendor: String? = nil,
                          iosVersion: String? = nil,
                          locale: String? = nil,
                          model: String? = nil,
                          originalTransactionId: String? = nil,
                          region: String? = nil,
                          timeZone: String? = nil) -> UserInfo {
        
        return UserInfo(appVersion: appVersion ?? "1.0",
                        userProperties: userProperty ?? [:],
                        deviceToken: deviceToken,
                        email: email,
                        identifierForVendor: identifierForVendor ?? "vendorIdentifier",
                        iosVersion: iosVersion ?? "13.0",
                        locale: locale ?? "en-US",
                        model: model ?? "iPhone 11",
                        originalTransactionId: originalTransactionId,
                        region: region ?? "US",
                        timeZone: timeZone ?? "America/New_York",
                        platform:"iOS")
    }
    
    func offerSignatureResponse() -> Data {
        
        let json = """
            {
                "keyIdentifier": "keyIdentifier",
                "nonce":"3049BAA5-DEC5-408C-9A5B-4728E1E1C890",
                "signature":"signatureString",
                "timestamp":1597776685
            }
        """
        return json.data(using: .utf8)!
    }
}
