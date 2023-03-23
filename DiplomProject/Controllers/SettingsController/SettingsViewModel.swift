//
//  SettingsViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import Foundation

final class SettingsViewModel {
    let realm: RealmManager
    let provider: ProviderManager
    
    var settingPoints = [[SettingsEnum]]()

    init(realm: RealmManager, provider: ProviderManager) {
        self.realm = realm
        self.provider = provider
    }
    
    func configureCells() {
        var sections = [[SettingsEnum]]()
        let firstSection: [SettingsEnum] = [.incomeTypes, .spendTypes]
        let secondSection: [SettingsEnum] = [.summFormat, .vibrations]
        let thirdSection: [SettingsEnum] = [.chooseColor, .chooseLanguage, .currency]
        let fourSection: [SettingsEnum] = [.deleteAllData]
        sections.append(firstSection)
        sections.append(secondSection)
        sections.append(thirdSection)
        sections.append(fourSection)
        settingPoints = sections
    }
    
    func changeNotificationLanguage() {
        realm.read(type: DebtModel.self).forEach { debt in
            if let _ = debt.notificationDate {
                NotificationManager().removePushFor(debt)
                NotificationManager().createPushFor(debt)
            }
        }
    }
    
    func deleteAllData() {
        realm.read(type: AccountModel.self).forEach { account in
            account.allCashFlows.forEach { flow in
                self.realm.delete(object: flow)
            }
            self.realm.delete(object: account)
        }
        
        realm.read(type: CashFlowCategory.self).forEach { type in
            self.realm.delete(object: type)
        }
        
        realm.read(type: DebtModel.self).forEach { debt in
            NotificationManager().removePushFor(debt)
            self.realm.delete(object: debt)
        }
    }
    
}
