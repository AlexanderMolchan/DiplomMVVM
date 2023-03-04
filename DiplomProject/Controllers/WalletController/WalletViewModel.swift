//
//  WalletViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import Foundation

class WalletViewModel {
    let realm: RealmManager
    let controllerType: ControllerType
    let currentAccount: AccountModel?

    let totalAccountSumm: Dynamic<String?> = Dynamic(nil)
    var groupedAccountFlows = [[CashModel]]()
    var accountArray = [AccountModel]()
    
    init(realm: RealmManager, type: ControllerType, currentAccount: AccountModel? = nil) {
        self.realm = realm
        self.controllerType = type
        self.currentAccount = currentAccount
    }
    
    func setupDataSource() {
        switch controllerType {
            case .wallet:   setupWalletDataSource()
            case .account:  setupAccountDataSource()
            default: break
        }
    }

    private func setupWalletDataSource() {
        accountArray = realm.read(type: AccountModel.self)
        var summ = 0.0
        accountArray.forEach { account in
            summ += account.currentSumm
        }
        totalAccountSumm.value = "\(Int(summ))"
    }

    private func setupAccountDataSource() {
        groupedAccountFlows.removeAll()
        guard let currentAccount else { return }
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
        setupAccountDataSource()
    }
    
    func deleteAllTransactions() {
        guard let currentAccount else { return }
        currentAccount.allCashFlows.forEach { transaction in
            self.realm.delete(object: transaction)
        }
        groupedAccountFlows.removeAll()
    }
    
    func deleteCurrentAccount() {
        guard let currentAccount else { return }
        deleteAllTransactions()
        realm.delete(object: currentAccount)
    }
    
}


