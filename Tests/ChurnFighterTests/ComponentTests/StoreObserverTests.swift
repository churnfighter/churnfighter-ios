//
//  StoreObserverTests.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 04/09/2020.
//

import XCTest
import StoreKit
@testable import ChurnFighter


final class StoreObserverTests: XCTestCase {
    
    private var storeObserver: StoreObserver!
    private var stubChurnFighter: StubChurnFighter!
    
    override func setUp() {
        super.setUp()
        storeObserver = StoreObserver()
        stubChurnFighter = StubChurnFighter()
        storeObserver.delegate = stubChurnFighter
    }
    
    override func tearDown() {
        
        storeObserver = nil
        stubChurnFighter = nil
        super.tearDown()
    }
    
    func testPaymentQueue_transactionContainsOriginalTransactionId_callsDelegateSetOriginalTransactionId() {
        
        let paymentQueue = SKPaymentQueue.default()
        
        let originalTransaction = StubPaymentTransaction(transactionId: "transactionID1",
                                                         transactionState: .purchased)
        let transaction = StubPaymentTransaction(transactionId: "",
                                                 originalTransactionId: originalTransaction,
                                                 transactionState: .purchased)
        
        storeObserver.paymentQueue(paymentQueue, updatedTransactions: [transaction])
        
        XCTAssertEqual(stubChurnFighter.setOriginalTransactionIdCalledWithId, "transactionID1")
    }
    
    func testPaymentQueue_transactionStateIsPurchased_callsDelegateLoadReceipt() {
        
        let paymentQueue = SKPaymentQueue.default()
        let transaction = StubPaymentTransaction(transactionId: "transactionID1", transactionState: .purchased)
        
        storeObserver.paymentQueue(paymentQueue, updatedTransactions: [transaction])
        
        XCTAssertTrue(stubChurnFighter.loadReceiptCalled)
    }
    
    func testPaymentQueue_transactionStateIsRestored_callsDelegateLoadReceipt() {
        
        let paymentQueue = SKPaymentQueue.default()
        let transaction = StubPaymentTransaction(transactionId: "transactionID1", transactionState: .restored)
        
        storeObserver.paymentQueue(paymentQueue, updatedTransactions: [transaction])
        
        XCTAssertTrue(stubChurnFighter.loadReceiptCalled)
    }
    
    func testPaymentQueue_transactionStateIsPurchasing_doesNotCallDelegateLoadReceipt() {
        
        let paymentQueue = SKPaymentQueue.default()
        let transaction = StubPaymentTransaction(transactionId: "transactionID1", transactionState: .purchasing)
        
        storeObserver.paymentQueue(paymentQueue, updatedTransactions: [transaction])
        
        XCTAssertFalse(stubChurnFighter.loadReceiptCalled)
    }
    
    func testPaymentQueue_transactionStateIsFailed_doesNotCallDelegateLoadReceipt() {
        
        let paymentQueue = SKPaymentQueue.default()
        let transaction = StubPaymentTransaction(transactionId: "transactionID1", transactionState: .failed)
        
        storeObserver.paymentQueue(paymentQueue, updatedTransactions: [transaction])
        
        XCTAssertFalse(stubChurnFighter.loadReceiptCalled)
    }
    
    func testPaymentQueue_transactionStateIsDeffered_doesNotCallDelegateLoadReceipt() {
        
        let paymentQueue = SKPaymentQueue.default()
        let transaction = StubPaymentTransaction(transactionId: "transactionID1", transactionState: .deferred)
        
        storeObserver.paymentQueue(paymentQueue, updatedTransactions: [transaction])
        
        XCTAssertFalse(stubChurnFighter.loadReceiptCalled)
    }
}

