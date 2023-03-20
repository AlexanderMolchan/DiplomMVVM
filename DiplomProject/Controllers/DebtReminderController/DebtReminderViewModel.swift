//
//  DebtReminderViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 20.03.23.
//

import Foundation

final class DebtReminderViewModel {
    let realm: RealmManager
    
    init(realm: RealmManager) {
        self.realm = realm
    }
    
    func writeObjectToRealm(object: DebtModel) {
        realm.write(object: object)
    }
}
