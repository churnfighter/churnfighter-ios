//
//  UserInfo.swift
//  ChurnFighter
//  


import Foundation

private let userInfoDefaultsKey = "userInfo"

struct UserInfo: Encodable, Decodable, Hashable {
    
    var appVersion: String
    var userProperties: [String:String]
    var deviceToken: String?
    var email: String?
    var identifierForVendor: String
    var iosVersion: String
    var locale: String
    var model: String
    var originalTransactionId: String?
    var region: String?
    var timeZone: String
    var platform: String
}

extension UserInfo {
    
    mutating func set(email: String) {
        
        self.email = email
    }
    
    mutating func set(deviceToken: String) {
        
        self.deviceToken = deviceToken
    }
    
    mutating func set(originalTransactionId: String) {
        
        self.originalTransactionId = originalTransactionId
    }
    
    mutating func set(userProperty:[String:String]) {

        self.userProperties.merge(userProperty) { (_, new) in new }
    }
}


extension UserInfo {
    
    static func loadFromUserDefaults(userDefaults: UserDefaults?) -> UserInfo? {
        
        let decoder = JSONDecoder()
        guard let userDefaults = userDefaults,
            let data = userDefaults.object(forKey: userInfoDefaultsKey) as? Data,
            let userInfo = try? decoder.decode(UserInfo.self, from: data) else {
                
                return nil
        }
        
        return userInfo
    }
    
    func saveToUserDefaults(userDefaults: UserDefaults?) {
        
        let encoder = JSONEncoder()
        if let userDefaults = userDefaults,
            let encoded = try? encoder.encode(self) {
            
            userDefaults.set(encoded, forKey: userInfoDefaultsKey)
        }
    }
}

