//
//  StubPaymentTransaction.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
import StoreKit


final class StubPaymentTransaction: SKPaymentTransaction {
    
    private let stubTransactionId: String
    private let stubOriginalTransactionId: StubPaymentTransaction?
    private let stubTransactionState: SKPaymentTransactionState
    
    init(transactionId: String,
         originalTransactionId: StubPaymentTransaction? = nil,
         transactionState: SKPaymentTransactionState) {
        
        self.stubTransactionId = transactionId
        self.stubOriginalTransactionId = originalTransactionId
        self.stubTransactionState = transactionState
    }
    
    override var original: SKPaymentTransaction? {
        
        get {
            
            return stubOriginalTransactionId
        }
    }
    
    override var transactionIdentifier: String {
        
        get {
            
            return stubTransactionId
        }
    }
    
    override var transactionState: SKPaymentTransactionState {
        
        get {
            return stubTransactionState
        }
    }
    
}
