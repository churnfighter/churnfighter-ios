//
//  ApiClientProtocol.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation

protocol ApiClientProtocol {
    func uploadUserInfo(userInfo: UserInfo, completion:  @escaping (Bool) -> Void)
    func uploadReceipt(receipt: String, userInfo: UserInfo, completion:  @escaping (Bool) -> Void)
    func subscriptionOfferSignature(offerIdentifier: String,
                                    productIdentifier: String,
                                    usernameHash: String,
                                    completion:  @escaping (String, UUID, String, Int ) -> Void)
}
