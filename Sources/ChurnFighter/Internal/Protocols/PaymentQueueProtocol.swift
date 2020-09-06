//
//  PaymentQueueProtocol.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
import StoreKit

protocol PaymentQueueProtocol {
    
    func add(_ observer: SKPaymentTransactionObserver)
    func remove(_ observer: SKPaymentTransactionObserver)
}

extension SKPaymentQueue: PaymentQueueProtocol {}
