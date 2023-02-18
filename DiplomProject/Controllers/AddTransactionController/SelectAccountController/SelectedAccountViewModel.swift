//
//  SelectedAccountViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import Foundation

class SelectedAccountViewModel {
    var controllerType: SelectedType
    var cashFlowType: CashFlowType
    
    var accountArray = RealmManager<AccountModel>().read()
    lazy var spendCategory = RealmManager<CashFlowCategory>().read().filter({ $0.type == cashFlowType })
    
    init(controllerType: SelectedType, cashFlowType: CashFlowType) {
        self.controllerType = controllerType
        self.cashFlowType = cashFlowType
    }
    
}
