//
//  DeviceProviding.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 18/08/2020.
//

import Foundation

#if os(OSX)
#else
import UIKit
#endif


protocol DeviceProviding {
    
    var identifierForVendor: UUID? { get }
    var localizedModel: String { get }
    var systemVersion: String { get }
}


#if os(OSX)
#else
extension UIDevice: DeviceProviding {}
#endif
