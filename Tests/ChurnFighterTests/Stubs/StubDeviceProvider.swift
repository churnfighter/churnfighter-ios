//
//  StubDeviceProvider.swift
//  ChurnFighter
//

import Foundation
@testable import ChurnFighter

final class StubDeviceProvider: DeviceProviding {
    
    private(set) var systemVersion: String
    private(set) var localizedModel: String
    private(set) var identifierForVendor: UUID?
    
    init(systemVersion: String,
         localizedModel: String,
         identifierForVendor: UUID?) {
        
        self.systemVersion = systemVersion
        self.localizedModel = localizedModel
        self.identifierForVendor = identifierForVendor
    }
}
