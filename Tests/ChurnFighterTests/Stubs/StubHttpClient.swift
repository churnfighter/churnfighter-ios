//
//  StubHttpClient.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 18/08/2020.
//

import Foundation
@testable import ChurnFighter

final class HttpError: Error {}

final class StubHttpClient: HttpClientProtocol {
    
    private(set) var url: URL?
    private(set) var jsonData: Data?
    private(set) var isError: Bool = false
    private(set) var data: Data = Data()
    private(set) var postCalled = false
    
    func setError(isError: Bool) {
        self.isError = isError
    }
    
    func setData(data: Data) {
        self.data = data
    }
    
    func post(url: URL, jsonData: Data, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        postCalled = true
        self.url = url
        self.jsonData = jsonData
        
        completion(data, nil, isError ? HttpError() : nil)
    }
}
