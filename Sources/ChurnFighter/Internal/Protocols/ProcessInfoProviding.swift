//
//  ProcessInfoProviding.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation

protocol ProcessInfoProviding {
    
    var operatingSystemVersionString: String { get }
}

extension ProcessInfo: ProcessInfoProviding {}
