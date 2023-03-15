//
//  AnalyticsViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import Foundation

final class AnalyticsViewModel {
    let realm: RealmManager
    
    var accountArray = [AccountModel]()
    var totalSumm = Double()
    
    init(realm: RealmManager) {
        self.realm = realm
    }
    
    func setupData() {
        var summFromAllAccounts = Double()
        accountArray = realm.read(type: AccountModel.self)
        accountArray.forEach { account in
            summFromAllAccounts += account.currentSumm
        }
        totalSumm = summFromAllAccounts
    }
    
}
