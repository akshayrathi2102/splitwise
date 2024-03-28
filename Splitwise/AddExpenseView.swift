//
//  AddExpenseView.swift
//  Splitwise
//
//  Created by Akshay Rathi on 28/03/24.
//

import Foundation
import UIKit
import SnapKit

final class AddExpenseView: UIView {
    private let addExpenseLabel = UILabel()
    private let totalLabel = UILabel()
    
    private let addExpenseTextField = UITextField()
    private let totalTextField = UITextField()
    
    private let paidByLabel = UILabel()
    private let paidByTextField = UITextField()
    
    private let participantsLabel = UILabel()
    private var participantsTextField: [UITextField] = [UITextField()]
    private let addParticipantButton = UIButton()
    private let participantsStackView = UIStackView()
    private let participantsScrollView = UIScrollView()
    
    private let addExpenseButton = UIButton()
    
    var onAddExpense: ((ExpenseModel) -> ())?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
        populateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews()
        addExpenseLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addExpenseLabel.numberOfLines = 1
        addExpenseLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(24)
        }
        
        addExpenseTextField.borderStyle = .roundedRect
        addExpenseTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerY.equalTo(addExpenseLabel)
            make.leading.equalTo(addExpenseLabel.snp.trailing).offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        totalLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        totalLabel.numberOfLines = 1
        totalLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(addExpenseLabel.snp.bottom).offset(24)
        }
        
        totalTextField.borderStyle = .roundedRect
        totalTextField.keyboardType = .decimalPad
        totalTextField.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel)
            make.top.equalTo(addExpenseTextField.snp.bottom).offset(24)
            make.leading.equalTo(totalLabel.snp.trailing).offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        paidByLabel.snp.makeConstraints { make in
            make.leading.equalTo(paidByTextField)
            make.top.equalTo(totalTextField.snp.bottom).offset(32)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        paidByTextField.borderStyle = .roundedRect
        paidByTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(64)
            make.top.equalTo(paidByLabel.snp.bottom).offset(24)
        }
        
        participantsLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        participantsLabel.numberOfLines = 1
        participantsLabel.snp.makeConstraints { make in
            make.leading.equalTo(paidByLabel)
            make.trailing.lessThanOrEqualToSuperview()
            make.top.equalTo(paidByTextField.snp.bottom).offset(24)
        }
        
        addParticipantButton.backgroundColor = .systemBlue
        addParticipantButton.layer.borderColor = UIColor.black.cgColor
        addParticipantButton.layer.borderWidth = 1
        addParticipantButton.addTarget(self, action: #selector(handleAddParticipant), for: .touchUpInside)
        addParticipantButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.centerY.equalTo(participantsLabel)
            make.trailing.lessThanOrEqualToSuperview().offset(-64)
        }
        
        participantsScrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(64)
            make.top.equalTo(participantsLabel.snp.bottom).offset(32)
            make.bottom.equalTo(addExpenseButton.snp.top).offset(-24)
        }
        
        participantsStackView.spacing = 12
        participantsStackView.axis = .vertical
        participantsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        for textFields in participantsTextField {
            textFields.borderStyle = .roundedRect
            participantsStackView.addArrangedSubview(textFields)
            textFields.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
        }
        
        addExpenseButton.backgroundColor = .systemBlue
        addExpenseButton.layer.borderColor = UIColor.black.cgColor
        addExpenseButton.layer.borderWidth = 1
        addExpenseButton.addTarget(self, action: #selector(handleAddExpenseTap), for: .touchUpInside)
        addExpenseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(64)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    private func addSubviews() {
        addSubview(addExpenseLabel)
        addSubview(totalLabel)
        addSubview(addExpenseTextField)
        addSubview(totalTextField)
        addSubview(paidByLabel)
        addSubview(paidByTextField)
        addSubview(participantsLabel)
        addSubview(participantsScrollView)
        participantsScrollView.addSubview(participantsStackView)
        addSubview(addExpenseButton)
        addSubview(addParticipantButton)
    }
    
    private func populateViews() {
        addExpenseLabel.text = "Expense"
        totalLabel.text = "Total"
        paidByLabel.text = "Paid by"
        participantsLabel.text = "Participants"
        addExpenseButton.setTitle("Add", for: .normal)
        addParticipantButton.setTitle("+", for: .normal)
    }
    
    @objc
    private func handleAddParticipant() {
        let textField = UITextField()
        participantsTextField.append(textField)
        textField.borderStyle = .roundedRect
        participantsStackView.addArrangedSubview(textField)
    }
    
    @objc
    private func handleAddExpenseTap() {
        guard let amountString = totalTextField.text,
        let amountDouble = Double(amountString) else {
            // handle error
            print("Invalid amount")
            return
        }
        
        guard let payer = paidByTextField.text else {
            // handle error
            print("Invalid name")
            return
        }
        
        var participants = [payer]
        for textField in participantsTextField {
            guard let payer = textField.text else {
                // handle error
                print("Invalid name")
                continue
            }
            participants.append(payer)
        }
                
        let expenseModel = ExpenseModel(amount: amountDouble,
                                        payer: payer,
                                        participants: participants)
        onAddExpense?(expenseModel)
    }
}
