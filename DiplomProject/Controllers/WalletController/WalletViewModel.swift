//
//  WalletViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import Foundation

class WalletViewModel {
    let realm: RealmManager
    let totalAccountSumm: Dynamic<String?> = Dynamic(nil)
    var accountArray = [AccountModel]()
    
    init(realm: RealmManager) {
        self.realm = realm
    }

    func reloadAccountData() {
        accountArray = realm.read(type: AccountModel.self)
        var summ = 0.0
        accountArray.forEach { account in
            summ += account.currentSumm
        }
        totalAccountSumm.value = "\(Int(summ))"
    }
    
}
