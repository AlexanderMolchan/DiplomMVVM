//
//  WalletViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import Foundation

class WalletViewModel {
    let totalAccountSumm: Dynamic<String?> = Dynamic(nil)
    
    var accountArray = RealmManager<AccountModel>().read()
    
    func reloadAccountData() {
        accountArray = RealmManager<AccountModel>().read()
        var summ = 0.0
        accountArray.forEach { account in
            summ += account.currentSumm
        }
        totalAccountSumm.value = "\(Int(summ))"
    }
    
}
