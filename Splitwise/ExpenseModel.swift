//
//  ExpenseModel.swift
//  Splitwise
//
//  Created by Akshay Rathi on 28/03/24.
//

import Foundation

struct ExpenseModel {
    let amount: Double
    let payer: String
    let participants: [String]
}

struct TransactionModel {
    let user: String
    // - amount means user owes that amount
    let amount: Double
}
