//
//  StubProcessInfoProvider.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
@testable import ChurnFighter

final class StubProcessInfoProvider: ProcessInfoProviding {
    
    private(set) var operatingSystemVersionString: String
    
    init(operatingSystemVersionString: String) {
        
        self.operatingSystemVersionString = operatingSystemVersionString
    }
}
