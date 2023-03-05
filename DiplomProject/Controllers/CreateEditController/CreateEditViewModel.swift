//
//  CreateEditViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import Foundation

class CreateEditViewModel {
    let realm: RealmManager
    var currentAccount: AccountModel?
    var currentCategory: CashFlowCategory?
    var controllerType: ControllerType
    var objectType: AccountOrCategoryType
    var categoryType: CashFlowType?
    
    init(realm: RealmManager, currentAccount: AccountModel? = nil, currentCategory: CashFlowCategory? = nil, controllerType: ControllerType, objectType: AccountOrCategoryType, categoryType: CashFlowType? = nil) {
        self.realm = realm
        self.currentAccount = currentAccount
        self.currentCategory = currentCategory
        self.controllerType = controllerType
        self.objectType = objectType
        self.categoryType = categoryType
    }
    
    func createAccount(name: String, summ: Double, isCredit: Bool?) {
        guard let isCredit else { return }
        let newAccount = AccountModel(name: name, creationgSumm: summ, isCreditAccount: isCredit)
        realm.write(object: newAccount)
    }
    
    func updateAccount(name: String, summ: Double, isCredit: Bool?) {
        guard let currentSumm = currentAccount?.currentSumm,
              let creationgSumm = currentAccount?.creationgSumm
               else { return }
        let cashFlows = creationgSumm - currentSumm
        let newAccountSumm = summ + cashFlows
        realm.update { realm in
            try? realm.write {
                self.currentAccount?.name = name
                self.currentAccount?.creationgSumm = newAccountSumm
                self.currentAccount?.isCreditAccount = isCredit!
            }
        }
    }
    
    func createCategory(name: String) {
        let isSpendingCategory = categoryType == .spending
        let newCategory = CashFlowCategory(name: name, isSpendingFlow: isSpendingCategory)
        realm.write(object: newCategory)
    }
    
    func updateCategory(name: String) {
        realm.update { realm in
            try? realm.write {
                self.currentCategory?.name = name
            }
        }
    }
    
}


