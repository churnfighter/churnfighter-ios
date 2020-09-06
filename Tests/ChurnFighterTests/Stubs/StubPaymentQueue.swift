//
//  StubPaymentQueue.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
import StoreKit
@testable import ChurnFighter

final class StubPaymentQueue: NSObject, PaymentQueueProtocol {
    
    private(set) var addCalled = false
    private(set) var removeCalled = false
    
    func add(_ observer: SKPaymentTransactionObserver) {
        
        addCalled = true
    }
    
    func remove(_ observer: SKPaymentTransactionObserver) {
        
        removeCalled = true
    }
}
