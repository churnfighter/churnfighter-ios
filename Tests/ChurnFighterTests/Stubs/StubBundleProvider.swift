//
//  StubBundleProvider.swift
//  ChurnFighter
//

import Foundation
@testable import ChurnFighter

final class StubBundleProvider: BundleProviding {
    
    private(set) var infoDictionary: [String : Any]?
    private(set) var appStoreReceiptURL: URL?
    
    init(infoDictionary: [String : Any]? = nil, appStoreReceiptURL: URL? = nil) {
        
        self.infoDictionary = infoDictionary
        self.appStoreReceiptURL = appStoreReceiptURL
    }
}
