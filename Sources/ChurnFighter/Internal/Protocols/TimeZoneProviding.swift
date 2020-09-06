//
//  TimeZoneProviding.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 18/08/2020.
//

import Foundation

protocol TimeZoneProviding {
    
    var identifier: String { get }
}

extension TimeZone: TimeZoneProviding {}
