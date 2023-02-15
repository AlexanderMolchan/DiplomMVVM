//
//  AddTransactionViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import Foundation

class AddTransactionViewModel {
    
    let cashFieldText: Dynamic<String?> = Dynamic(nil)
    let actionButtonIsEnabled: Dynamic<Bool> = Dynamic(true)
    let deleteButtonIsEnabled: Dynamic<Bool> = Dynamic(false)
    let selectedAccountName: Dynamic<String?> = Dynamic(nil)
    let selectedCategoryName: Dynamic<String?> = Dynamic(nil)
    let transactionCreateError: Dynamic<createTransactionError?> = Dynamic(nil)
    
    private var textForCashLabel = "" {
        didSet {
            cashFieldText.value = textForCashLabel
        }
    }
    
    var selectedAccount: AccountModel? {
        didSet {
            selectedAccountName.value = selectedAccount?.name
        }
    }
    
    var selectedCategory: String? {
        didSet {
            selectedCategoryName.value = selectedCategory
        }
    }
    
    private var numbersCount = 0
    private var limitForDot = 0
    var cashFlowType: CashFlowType = .spending
    
    func buttonAction(number: String) {
        if number == "0", numbersCount == 0 {
            return
        } else {
            textForCashLabel += number
            addNumbersCount(with: 1)
        }
    }
    
    func deleteAction() {
        if textForCashLabel == "0." {
            clearAll()
        }
        if numbersCount > 0 {
            textForCashLabel.removeLast()
            addNumbersCount(with: -1)
        }
    }
    
    func clearAll() {
        textForCashLabel.removeAll()
        numbersCount = 0
        addLimit()
    }
    
    func actionForDotButton() {
        if textForCashLabel.isEmpty {
            textForCashLabel += "0."
            limitForDot = textForCashLabel.count + 1
            addNumbersCount(with: 1)
        }
        if textForCashLabel.contains(".") {
            return
        }
        if !textForCashLabel.isEmpty {
            textForCashLabel += "."
            limitForDot = textForCashLabel.count + 2
            addNumbersCount(with: 1)
        }
    }
    
    private func addNumbersCount(with num: Int) {
        numbersCount += num
        addLimit()
    }
    
    private func addLimit() {
        var limit = numbersCount < 11
        if textForCashLabel.contains(".") {
            limit = numbersCount < limitForDot
        }
        actionButtonIsEnabled.value = limit
        deleteButtonIsEnabled.value = numbersCount > 0
    }
    
    func enterAction() {
        guard !textForCashLabel.isEmpty else { return transactionCreateError.value = .emptyField }
        guard let selectedAccount else { return transactionCreateError.value = .unselectedAccount }
        guard let selectedCategory else { return transactionCreateError.value = .unselectedCategory }
        guard let summ = Double(textForCashLabel) else { return }
        let accountType = selectedAccount.type.rawValue
        let cashFlowType = cashFlowType.rawValue
        if summ > 0.0 {
            let ownerID = selectedAccount.id
            let object = CashModel(summ: summ, accountTypeRawValue: accountType, cashFlowType: cashFlowType, ownerID: ownerID)
            RealmManager<CashModel>().write(object: object)
            clearAll()
            transactionCreateError.value = .allIsGood
        }
    }
    
}
    
enum createTransactionError {
    case emptyField
    case unselectedAccount
    case unselectedCategory
    case allIsGood
}
