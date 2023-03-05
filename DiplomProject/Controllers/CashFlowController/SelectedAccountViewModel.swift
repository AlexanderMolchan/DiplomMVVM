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
    lazy var selectedIndex = IndexPath(row: 0, section: 0)
    
    lazy var accountArray = realm.read(type: AccountModel.self)
    lazy var cashFlowCategoryArray = realm.read(type: CashFlowCategory.self).filter({ $0.type == cashFlowType })
    
    init(controllerType: SelectedType, controllerSubType: ControllerType, cashFlowType: CashFlowType, realm: RealmManager) {
        self.controllerType = controllerType
        self.controllerSubType = controllerSubType
        self.cashFlowType = cashFlowType
        self.realm = realm
    }
    
    func setupFlowData() {
        cashFlowCategoryArray = realm.read(type: CashFlowCategory.self).filter({ $0.type == cashFlowType })
    }
    
    func deleteCategoryFromRealm(indexPath: IndexPath) {
        let category = cashFlowCategoryArray[indexPath.row]
        let allFows = realm.read(type: CashModel.self).filter({ $0.category?.name == category.name })
        allFows.forEach { flow in
            realm.delete(object: flow)
        }
        realm.delete(object: category)
        setupFlowData()
    }
    
}
