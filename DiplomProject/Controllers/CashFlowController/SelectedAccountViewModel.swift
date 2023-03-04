//
//  SelectedAccountViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import Foundation

class SelectedAccountViewModel {
    let realm: RealmManager
    var controllerType: SelectedType
    var controllerSubType: ControllerType
    var cashFlowType: CashFlowType
    
    lazy var accountArray = realm.read(type: AccountModel.self)
    lazy var cashFlowCategoryArray = realm.read(type: CashFlowCategory.self).filter({ $0.type == cashFlowType })
    
    init(controllerType: SelectedType, controllerSubType: ControllerType, cashFlowType: CashFlowType, realm: RealmManager) {
        self.controllerType = controllerType
        self.controllerSubType = controllerSubType
        self.cashFlowType = cashFlowType
        self.realm = realm
    }
    
}
