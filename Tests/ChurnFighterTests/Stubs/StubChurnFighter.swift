//
//  StubChurnFighter.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
@testable import ChurnFighter

final class StubChurnFighter: ChurnFighterDelegate {
    
    private(set) var setOriginalTransactionIdCalledWithId: String?
    private(set) var loadReceiptCalled = false
    
    func setOriginalTransactionId(originalTransactionId: String) {
        
        setOriginalTransactionIdCalledWithId = originalTransactionId
    }
    
    func loadReceipt() {
        
        loadReceiptCalled = true
    }
}

