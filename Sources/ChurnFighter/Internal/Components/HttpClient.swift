//
//  HttpClient.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 18/08/2020.
//

import Foundation

final class HttpClient: HttpClientProtocol {
    
    private let secret: String
    private let urlSession: URLSessionProtocol
    
    init(secret: String) {
        
        self.secret = secret
        self.urlSession = URLSession.shared
    }
    
    init(secret: String, urlSession: URLSessionProtocol) {
        
        self.secret = secret
        self.urlSession = urlSession
    }
 
    func post(url: URL,
              jsonData: Data,
              completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard !jsonData.isEmpty else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue(secret, forHTTPHeaderField: "X-CF-header")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: request, completionHandler:completion)
        task.resume()
    }
}
    
