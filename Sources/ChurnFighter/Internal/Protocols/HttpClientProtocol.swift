//
//  HttpClientProtocol.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 18/08/2020.
//

import Foundation

protocol HttpClientProtocol {
    
    func post(url: URL, jsonData: Data,  completion:  @escaping (Data?, URLResponse?, Error?) -> Void)
}
