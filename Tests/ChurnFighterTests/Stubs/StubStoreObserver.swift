//
//  StubStoreObserver.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
import StoreKit
@testable import ChurnFighter

final class StubStoreObserver: NSObject, StoreObserverProtocol {
    
    var delegate: ChurnFighterDelegate?
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}
