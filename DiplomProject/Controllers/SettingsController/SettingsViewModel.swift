//
//  SettingsViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import Foundation

class SettingsViewModel {
    let realm: RealmManager
    
    var settingPoints = [[SettingsEnum]]()

    init(realm: RealmManager) {
        self.realm = realm
    }
    
    func configureCells() {
        var sections = [[SettingsEnum]]()
        let firstSection: [SettingsEnum] = [.incomeTypes, .spendTypes]
        let secondSection: [SettingsEnum] = [.summFormat, .vibrations]
        let thirdSection: [SettingsEnum] = [.chooseColor, .chooseLanguage]
        let fourSection: [SettingsEnum] = [.deleteAllData]
        sections.append(firstSection)
        sections.append(secondSection)
        sections.append(thirdSection)
        sections.append(fourSection)
        settingPoints = sections
    }
    
}
