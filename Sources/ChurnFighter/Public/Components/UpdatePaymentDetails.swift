//
//  UpdatePaymentDetails.swift
//  ChurnFighter
//


import Foundation

@objcMembers
final public class UpdatePaymentDetails: NSObject, ActionProtocol , Decodable {
    
    public let body: String
    public let cta: String
    public let title: String
    public let url: String
}
