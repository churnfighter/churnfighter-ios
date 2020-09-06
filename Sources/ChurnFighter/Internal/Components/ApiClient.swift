//
//  ChurnFighter.swift
//  ChurnFighter
//

import Foundation

final class ApiClient: ApiClientProtocol {
    
    private let httpClient: HttpClientProtocol
    
    private let userEndPoint: URL
    private let receiptEndPoint: URL
    private let offerSignatureEndpoint: URL
    
    
    init(apiKey: String, httpClient: HttpClientProtocol) {
        
        self.httpClient = httpClient
        
        let userEndPoint = URL(string: "https://api.churnfighter.io/user")?.appendingPathComponent(apiKey)
        let receiptEndPoint = URL(string: "https://api.churnfighter.io/receipt/ios")?.appendingPathComponent(apiKey)
        let offerSignatureEndpoint = URL(string:"https://api.churnfighter.io/subscriptionOfferSignature")?.appendingPathComponent(apiKey)

        assert(userEndPoint != nil)
        assert(receiptEndPoint != nil)
        assert(offerSignatureEndpoint != nil)

        self.userEndPoint = userEndPoint!
        self.receiptEndPoint = receiptEndPoint!
        self.offerSignatureEndpoint = offerSignatureEndpoint!
    }
    
    convenience init(apiKey: String, secret: String) {
        let httpClient = HttpClient(secret: secret)
        self.init(apiKey: apiKey, httpClient: httpClient)
    }
    
    func uploadUserInfo(userInfo: UserInfo, completion:  @escaping (Bool) -> Void) {
        
        // don't upload user data unless we have an email or a PN device token
        guard userInfo.email != nil || userInfo.deviceToken != nil else { return }

        if let userInfoData = try? JSONEncoder().encode(userInfo) {
            
            httpClient.post(url: userEndPoint, jsonData: userInfoData, completion: {_,_,_ in })
        }
    }
    
    func uploadReceipt(receipt: String, userInfo: UserInfo, completion:  @escaping (Bool) -> Void) {
        
        // don't upload receipt unless we have an email or a PN device token
        guard userInfo.email != nil || userInfo.deviceToken != nil else {
            
            completion(false)
            return
        }
        
        let jsonObject = ["receipt": receipt]
        let userId = userInfo.identifierForVendor
        let url = receiptEndPoint.appendingPathComponent(userId)
        
        if let json = try? JSONEncoder().encode(jsonObject) {
            
            httpClient.post(url: url, jsonData: json) { (_, _, error) in
                
                completion(error == nil)
            }
        }
    }
    
    

    func subscriptionOfferSignature(offerIdentifier: String,
                                    productIdentifier: String,
                                    usernameHash: String,
                                    completion:  @escaping (String, UUID, String, Int ) -> Void) {
        
        let jsonObject = ["applicationUsername": usernameHash,
                          "productIdentifier": productIdentifier,
                          "offerIdentifier": offerIdentifier];
        
        if let json = try? JSONEncoder().encode(jsonObject) {
            
            httpClient.post(url: offerSignatureEndpoint, jsonData: json) { (resultData, urlResponse, error) in
                
                if let data = resultData,
                    let subscribtionSignature = try? JSONDecoder().decode(OfferSignature.self, from: data) {
                    
                    completion(subscribtionSignature.keyIdentifier,
                               subscribtionSignature.nonce,
                               subscribtionSignature.signature,
                               subscribtionSignature.timestamp)
                }
            }
        }
    }
}

