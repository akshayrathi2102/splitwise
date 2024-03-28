//
//  ExpenseViewModel.swift
//  Splitwise
//
//  Created by Akshay Rathi on 28/03/24.
//

import Foundation

typealias User = String

final class ExpenseViewModel {
    private var ledger: [User: [TransactionModel]] = [:]
    // For ordering
    private var users: [User] = []
    
    var numberOfUsers: Int {
        users.count
    }
    
    func getBalance(for indexPath: IndexPath) -> (User, Double)? {
        let idx = indexPath.row
        if idx >= numberOfUsers {
            return nil
        }
        let transactions = ledger[users[idx]]
        let balance: Double? = transactions?.reduce(0.0, { partialResult, model in
            return partialResult + model.amount
        })
        
        if let balance {
            return (users[idx], balance)
        }
        return nil
    }
    
    
    func addExpense(expense: ExpenseModel) {
        let totalParticipants = Double(expense.participants.count)
        if totalParticipants == .zero {
            return
        }
        let perPersonAmount = expense.amount / totalParticipants
        for participant in expense.participants {
            if !users.contains(participant) {
                users.append(participant)
            }
            if participant != expense.payer {
                ledger[participant]?.append(.init(user: expense.payer,
                                                  amount: -perPersonAmount))
                ledger[expense.payer]?.append(.init(user: participant,
                                                  amount: perPersonAmount))
            }
        }
        print(expense)
    }
}
