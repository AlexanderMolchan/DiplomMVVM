//
//  AccountInfoViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import Foundation

class AccountInfoViewModel {
    var currentAccount: AccountModel
    var accountFlows = [CashModel]()
    
    init(currentAccount: AccountModel) {
        self.currentAccount = currentAccount
    }
    
    func setupFlows() {
        accountFlows = RealmManager<CashModel>().read().filter({ $0.ownerID == currentAccount.id })
    }
}
