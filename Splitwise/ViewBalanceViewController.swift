//
//  ViewBalanceViewController.swift
//  Splitwise
//
//  Created by Akshay Rathi on 28/03/24.
//

import Foundation
import UIKit

final class ViewBalanceViewController: UIViewController {
    private let viewModel: ExpenseViewModel
    private let contentView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    init(viewModel: ExpenseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        contentView.delegate = self
        contentView.dataSource = self
        contentView.register(BalanceTVC.self, forCellReuseIdentifier: "UITableViewCell")
        setupViews()
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

extension ViewBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        guard let data = viewModel.getBalance(for: indexPath),
              let balanceCell = cell as? BalanceTVC else { return cell }
        balanceCell.config(title: data.0, balance: data.1)
        return balanceCell
    }
}

final class BalanceTVC: UITableViewCell {
    private let titleLabel = UILabel()
    private let balanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, balance: Double) {
        titleLabel.text = title
        balanceLabel.text = String(balance)
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(balanceLabel)
        
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(32)
        }
        
        balanceLabel.numberOfLines = 1
        balanceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balanceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalTo(titleLabel.snp.trailing).offset(24)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(32)
        }
    }
}
