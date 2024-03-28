//
//  AddExpenseViewController.swift
//  Splitwise
//
//  Created by Akshay Rathi on 28/03/24.
//

import Foundation
import UIKit

final class AddExpenseViewController: UIViewController {
    private let viewModel: ExpenseViewModel
    private let contentView = AddExpenseView()
    
    init(viewModel: ExpenseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupViews()
        contentView.onAddExpense = { [weak self] expense in
            guard let viewModel = self?.viewModel else { return }
            viewModel.addExpense(expense: expense)
            self?.navigationController?.pushViewController(ViewBalanceViewController(viewModel: viewModel), animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(64)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
