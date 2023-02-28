//
//  AccountInfoViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import Foundation

class AccountInfoViewModel {
    let realm: RealmManager
    var currentAccount: AccountModel
    var groupedAccountFlows = [[CashModel]]()
    
    init(currentAccount: AccountModel, realm: RealmManager) {
        self.currentAccount = currentAccount
        self.realm = realm
    }
    
    func setupFlows() {
        groupedAccountFlows.removeAll()
        let accountFlows = realm.read(type: CashModel.self).filter({ $0.ownerID == currentAccount.id })
        let groupedFlows = Dictionary.init(grouping: accountFlows) { element in
            return element.stringDate
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let sortedKeys = groupedFlows.keys.sorted { dateFormatter.date(from: $0) ?? Date.now > dateFormatter.date(from: $1) ?? Date.now }
        sortedKeys.forEach { key in
            guard let values = groupedFlows[key] else { return }
            let sortedValues = values.sorted { $0.date > $1.date }
            groupedAccountFlows.append(sortedValues)
        }
    }
    
    func deleteElementFromRealmAt(indexPath: IndexPath) {
        let objectForDelete = groupedAccountFlows[indexPath.section][indexPath.row]
        realm.delete(object: objectForDelete)
        setupFlows()
    }
    
}
