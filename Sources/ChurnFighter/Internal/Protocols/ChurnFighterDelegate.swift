//
//  ChurnFighterDelegate.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import Foundation

protocol ChurnFighterDelegate {
    
    func setOriginalTransactionId(originalTransactionId: String)
    func loadReceipt()
}
