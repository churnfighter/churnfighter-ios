//
//  URLSessionProtocol.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation

protocol URLSessionProtocol {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}