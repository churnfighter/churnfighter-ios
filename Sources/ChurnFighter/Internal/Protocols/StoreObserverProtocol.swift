//
//  StoreObserverProtocol.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation
import StoreKit

protocol StoreObserverProtocol: SKPaymentTransactionObserver {
     
    var delegate: ChurnFighterDelegate? { get set }
}
