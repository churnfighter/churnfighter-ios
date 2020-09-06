//
//  BundleProviding.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 18/08/2020.
//

import Foundation

protocol BundleProviding {
    
    var infoDictionary:  [String : Any]? { get }
    var appStoreReceiptURL: URL? { get }
}

extension Bundle: BundleProviding {}
