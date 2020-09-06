//
//  MacDeviceProvider.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation

final class MacDeviceProvider: DeviceProviding {
    
    private let processInfoProvider: ProcessInfoProviding
    
    convenience init() {
        
        self.init(processInfoProvider: ProcessInfo.processInfo)
    }
    
    init(processInfoProvider: ProcessInfoProviding) {
        
        self.processInfoProvider = processInfoProvider
    }
    
    var identifierForVendor: UUID? {
        
        get {
            
            return UUID()
        }
    }
    
    var localizedModel: String {
        
        get {
            
            return "na"
        }
    }
    
    var systemVersion: String {
        
        get {
            
            return processInfoProvider.operatingSystemVersionString
        }
    }
}
