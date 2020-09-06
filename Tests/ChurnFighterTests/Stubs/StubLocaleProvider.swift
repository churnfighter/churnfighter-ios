//
//  StubLocaleProvider.swift
//  ChurnFighter
//

import Foundation
@testable import ChurnFighter


final class StubLocaleProvider: LocaleProviding {
    
    private(set) var identifier: String
    private(set) var regionCode: String?
    
    init(identifier: String, regionCode: String?) {
        
        self.identifier = identifier
        self.regionCode = regionCode
    }
}
