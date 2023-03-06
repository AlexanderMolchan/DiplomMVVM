//
//  AnalyticsViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import Foundation

class AnalyticsViewModel {
    let realm: RealmManager
    
    var accountArray = [AccountModel]()
    var totalSumm = Double()
    
    init(realm: RealmManager) {
        self.realm = realm
    }
    
    func setupData() {
        accountArray = realm.read(type: AccountModel.self)
        accountArray.forEach { account in
            totalSumm += account.currentSumm
        }
    }
    
}
