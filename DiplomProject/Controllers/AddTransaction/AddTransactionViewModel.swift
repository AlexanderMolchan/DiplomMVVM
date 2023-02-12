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
    
    func buttonAction() {
        textForCashLabel += "1"
    }
    
}
