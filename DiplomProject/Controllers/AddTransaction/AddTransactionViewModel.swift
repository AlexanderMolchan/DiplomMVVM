//
//  AddTransactionViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import Foundation

class AddTransactionViewModel {
    
    let cashFieldText: Dynamic<String?> = Dynamic(nil)
    
    private var textForCashLabel = "" {
        didSet {
            cashFieldText.value = textForCashLabel
        }
    }
    private var numbersCount = 0
    
    func buttonAction(number: String) {
        textForCashLabel += number
        
    }
    
    func addNumbersCount(with num: Int) {
        numbersCount += num
   //     addLimit()
    }
    
}
