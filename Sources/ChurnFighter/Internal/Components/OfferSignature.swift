//
//  OfferSignature.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation

struct OfferSignature: Decodable {
    
    let keyIdentifier: String
    let nonce: UUID
    let signature: String
    let timestamp: Int
}
