//
//  UserInfoTests.swift
//  ChurnFighter
//

import XCTest
@testable import ChurnFighter

final class UserInfoTests: XCTestCase {
    
    private var testUserDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        testUserDefaults = UserDefaults(suiteName: #file)
        testUserDefaults.removePersistentDomain(forName: #file)
    }
    
    override func tearDown() {
        
        testUserDefaults = nil
        
        super.tearDown()
    }
    
    
    // Email
    
    func testSetEmail_previousValueIsNil_updatesEmail() {
        
        var userInfo = generateUserInfo(email: nil)
        XCTAssertNil(userInfo.email)
        
        userInfo.set(email: "newEmailValue")
        XCTAssertEqual(userInfo.email, "newEmailValue")
    }
    
    func testSetEmail_previousValueIsNotNil_updatesEmail() {
        
        var userInfo = generateUserInfo(email: "previousEmailValue")
        XCTAssertEqual(userInfo.email, "previousEmailValue")
        
        userInfo.set(email: "newEmailValue")
        XCTAssertEqual(userInfo.email, "newEmailValue")
    }
    
    // DeviceToken
    
    func testSetDeviceToken_previousValueIsNil_updatesDeviceToken() {
        
        var userInfo = generateUserInfo()
        XCTAssertNil(userInfo.deviceToken)
        
        userInfo.set(deviceToken: "newDeviceToken")
        XCTAssertEqual(userInfo.deviceToken, "newDeviceToken")
    }
    
    func testSetDeviceToken_previousValueIsNotNil_updatesDeviceToken() {
        
        var userInfo = generateUserInfo(deviceToken: "previousDeviceToken")
        XCTAssertEqual(userInfo.deviceToken, "previousDeviceToken")
        
        userInfo.set(deviceToken: "newDeviceToken")
        XCTAssertEqual(userInfo.deviceToken, "newDeviceToken")
    }
    
    // OriginalTransactionId
    
    func testSetOriginalTransactionId_previousValueIsNil_updatesOriginalTransactionId() {
        
        var userInfo = generateUserInfo()
        XCTAssertNil(userInfo.originalTransactionId)
        
        userInfo.set(originalTransactionId: "newOriginalTransactionID")
        XCTAssertEqual(userInfo.originalTransactionId, "newOriginalTransactionID")
    }
    
    func testSetOriginalTransactionId_previousValueIsNotNil_updatesOriginalTransactionId() {
        
        var userInfo = generateUserInfo(originalTransactionId: "previousTransactionId")
        XCTAssertEqual(userInfo.originalTransactionId, "previousTransactionId")
        
        userInfo.set(originalTransactionId: "newOriginalTransactionID")
        XCTAssertEqual(userInfo.originalTransactionId, "newOriginalTransactionID")
    }
    
    // userProperties
    
    func testSetUserProperty_previousPropertiesEmpty_addsUserProperty() {
        
        var userInfo = generateUserInfo(userProperty: [:])
        XCTAssertEqual(userInfo.userProperties.count, 0)
        
        userInfo.set(userProperty: ["firstName" : "John"])
        XCTAssertEqual(userInfo.userProperties.count, 1)
        XCTAssertEqual(userInfo.userProperties["firstName"], "John")
    }
    
    func testSetUserProperty_previousPropertiesNotEmpty_addsUserProperty() {
        
        var userInfo = generateUserInfo(userProperty:  ["firstName" : "John"])
        XCTAssertEqual(userInfo.userProperties.count, 1)
        XCTAssertEqual(userInfo.userProperties["firstName"], "John")
        
        userInfo.set(userProperty: ["lastName" : "Appleseed"])
        XCTAssertEqual(userInfo.userProperties.count, 2)
        XCTAssertEqual(userInfo.userProperties["firstName"], "John")
        XCTAssertEqual(userInfo.userProperties["lastName"], "Appleseed")
    }
    
    // loadFromUserDefaults
    
    func testLoadFromUserDefaults_userInfoDoesNotExistInUserDefaults_returnsNil() {
        
        testUserDefaults.set(nil, forKey: "userInfo")
        
        let userInfo = UserInfo.loadFromUserDefaults(userDefaults: testUserDefaults)
        XCTAssertNil(userInfo)
    }
    
    func testLoadFromUserDefaults_userInfoJSONExistInUserDefaults_returnsUserInfoFromUserDefaults() {
        
        populateTestUserDefaultWithValues()
        
        guard let userInfo = UserInfo.loadFromUserDefaults(userDefaults: testUserDefaults) else {
            XCTFail("no userInfo")
            return
        }
        
        XCTAssertEqual(userInfo.appVersion, "1.0")
        XCTAssertEqual(userInfo.userProperties, ["firstName":"John"])
        XCTAssertEqual(userInfo.email, "john@apple.com")
        XCTAssertEqual(userInfo.identifierForVendor, "identifierForVendorValue")
        XCTAssertEqual(userInfo.iosVersion, "12.0")
        XCTAssertEqual(userInfo.locale, "en-US")
        XCTAssertEqual(userInfo.model, "iPhone 11")
        XCTAssertEqual(userInfo.originalTransactionId, "originalTransactionId")
        XCTAssertEqual(userInfo.deviceToken, "deviceTokenValue")
        XCTAssertEqual(userInfo.region, "US")
        XCTAssertEqual(userInfo.timeZone, "America/New_York")
    }
    
    // saveToUserDefaults
    
    func testSaveToUserDefaults_savesCorrectJSONToUserDefaults() {
        
        let userInfo = UserInfo(appVersion: "2.0",
                                userProperties: ["firstName":"barack", "lastName":"Obama"],
                                deviceToken: "deviceTokenValue",
                                email: "barack@whitehouse.gov",
                                identifierForVendor: "identifierA",
                                iosVersion: "10.0",
                                locale: "fr-FR",
                                model: "iPhone 7",
                                originalTransactionId: "transactionId1",
                                region: "FR",
                                timeZone: "France/Paris",
                                platform:"iOS")
        
        userInfo.saveToUserDefaults(userDefaults: testUserDefaults)
        
        guard let data = testUserDefaults.value(forKey: "userInfo") as? Data else {
            XCTFail("can't read value in test UserDefaults")
            return
        }
        let jsonString = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(jsonString, "{\"userProperties\":{\"firstName\":\"barack\",\"lastName\":\"Obama\"},\"iosVersion\":\"10.0\",\"originalTransactionId\":\"transactionId1\",\"deviceToken\":\"deviceTokenValue\",\"locale\":\"fr-FR\",\"platform\":\"iOS\",\"timeZone\":\"France\\/Paris\",\"identifierForVendor\":\"identifierA\",\"region\":\"FR\",\"appVersion\":\"2.0\",\"model\":\"iPhone 7\",\"email\":\"barack@whitehouse.gov\"}")
        
    }
}

private extension UserInfoTests {
    
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
                        platform: "iOS")
    }
    
    func populateTestUserDefaultWithValues() {
        
        let userInfoJSON = """
            {
              "appVersion": "1.0",
              "userProperties": {"firstName":"John"},
              "deviceToken": "deviceTokenValue",
              "email": "john@apple.com",
              "identifierForVendor": "identifierForVendorValue",
              "iosVersion": "12.0",
              "locale": "en-US",
              "model": "iPhone 11",
              "originalTransactionId": "originalTransactionId",
              "region": "US",
              "timeZone": "America/New_York",
              "platform": "iOS"
            }
            """
        
        testUserDefaults.set(userInfoJSON.data(using: .utf8), forKey: "userInfo")
    }
}
