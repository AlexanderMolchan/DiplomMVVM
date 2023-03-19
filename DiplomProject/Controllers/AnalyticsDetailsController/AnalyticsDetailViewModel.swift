//
//  AnalyticsDetailViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 19.03.23.
//

import Foundation

final class AnalyticsDetailViewModel {
    var account: AccountModel
    var type: CardViewMode
    var totalSumm: Double
    var realm: RealmManager
    
    var groupedAccountFlows = [[CashModel]]()
    
    init(account: AccountModel, type: CardViewMode, totalSumm: Double, realm: RealmManager) {
        self.account = account
        self.type = type
        self.totalSumm = totalSumm
        self.realm = realm
    }
    
    func createDataGroups() {
        let accountFlows = account.allCashFlows
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
