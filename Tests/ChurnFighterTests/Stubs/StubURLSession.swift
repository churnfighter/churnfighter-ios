//
//  StubURLSession.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
@testable import ChurnFighter

final class StubURLSession: URLSessionProtocol {
    
    private(set) var requestSent: URLRequest?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        requestSent = request
                
        return URLSessionDataTask()
    }
}
