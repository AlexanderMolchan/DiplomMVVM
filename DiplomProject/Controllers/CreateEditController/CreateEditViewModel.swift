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
    var controllerType: ControllerType
    
    init(realm: RealmManager, currentAccount: AccountModel? = nil, controllerType: ControllerType) {
        self.realm = realm
        self.currentAccount = currentAccount
        self.controllerType = controllerType
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
    
}

enum ControllerType {
    case edit
    case create
}
