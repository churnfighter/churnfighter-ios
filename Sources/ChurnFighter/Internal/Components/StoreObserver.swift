//
//  StoreObserver.swift
//  ChurnFighter
//


import Foundation
import StoreKit

final class StoreObserver: NSObject, StoreObserverProtocol {
    
    var delegate: ChurnFighterDelegate?
    
    func paymentQueue(_ queue: SKPaymentQueue,updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            if let originalTransaction = transaction.original,
                let originalTransactionIdentifier = originalTransaction.transactionIdentifier {
                delegate?.setOriginalTransactionId(originalTransactionId: originalTransactionIdentifier)
            }
            
            switch transaction.transactionState {
                
            case .purchased, .restored:
                delegate?.loadReceipt()
                break
    
             default:
                break
            }
        }
    }
}
