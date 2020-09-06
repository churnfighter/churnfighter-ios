//
//  StubApiClient.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
@testable import ChurnFighter


final class StubApiClient: ApiClientProtocol {
    
    private(set) var uploadReceiptCalled = false
    
    func uploadUserInfo(userInfo: UserInfo, completion: @escaping (Bool) -> Void) {
        
    }
    
    func uploadReceipt(receipt: String, userInfo: UserInfo, completion: @escaping (Bool) -> Void) {
        
        uploadReceiptCalled = true
    }
    
    func subscriptionOfferSignature(offerIdentifier: String, productIdentifier: String, usernameHash: String, completion: @escaping (String, UUID, String, Int) -> Void) {
        
    }
    
    
}
