//
//  StubTimeZoneProvider.swift
//  ChurnFighter
//


import Foundation
@testable import ChurnFighter


final class StubTimeZoneProvider: TimeZoneProviding {
    
    private(set) var identifier: String
    
    init(identifier: String) {
        
        self.identifier = identifier
    }
}
