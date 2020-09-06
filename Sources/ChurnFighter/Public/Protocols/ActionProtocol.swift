//
//  ActionProtocol.swift
//  
//
//  Created by ChurnFighter on 11/08/2020.
//

import Foundation

@objc
public protocol ActionProtocol: NSObjectProtocol {
    
    var body: String { get }
    var title: String { get }
}
