//
//  LocaleProviding.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 18/08/2020.
//

import Foundation

protocol LocaleProviding {
    
    var identifier: String { get }
    var regionCode: String? { get }
}

extension Locale: LocaleProviding {}
