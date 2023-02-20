//
//  AccountInfoViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import Foundation

class AccountInfoViewModel {
    var currentAccount: AccountModel
    var groupedAccountFlows = [[CashModel]]()
    
    init(currentAccount: AccountModel) {
        self.currentAccount = currentAccount
    }
    
    func setupFlows() {
       let accountFlows = RealmManager<CashModel>().read().filter({ $0.ownerID == currentAccount.id })
        
        let groupedFlows = Dictionary.init(grouping: accountFlows) { element in
            return element.stringDate
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let sortedKeys = groupedFlows.keys.sorted { dateFormatter.date(from: $0) ?? Date.now > dateFormatter.date(from: $1) ?? Date.now }
        
        sortedKeys.forEach { key in
            guard let values = groupedFlows[key] else { return }
            groupedAccountFlows.append(values)
        }
    }
    
}
