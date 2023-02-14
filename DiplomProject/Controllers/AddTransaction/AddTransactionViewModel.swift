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

    
    private var textForCashLabel = "" {
        didSet {
            cashFieldText.value = textForCashLabel
        }
    }
    private var numbersCount = 0
    private var limitForDot = 0
    
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
            clearLabel()
        }
        if numbersCount > 0 {
            textForCashLabel.removeLast()
            addNumbersCount(with: -1)
  //          deleteAll()
        }
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
    
    func addNumbersCount(with num: Int) {
        numbersCount += num
        addLimit()
    }
    
    private func clearLabel() {
        textForCashLabel.removeAll()
        numbersCount = 0
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
    
    }
    

