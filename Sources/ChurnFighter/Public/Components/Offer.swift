//
//  Offer.swift
//  ChurnFighter
//

import Foundation

@objcMembers
final public class Offer: NSObject, ActionProtocol, Decodable {
    
    public let title: String
    public let body: String
    public let productId: String
    public let offerId: String?
    public let offerType: String
    public let productDescription: String?
}
