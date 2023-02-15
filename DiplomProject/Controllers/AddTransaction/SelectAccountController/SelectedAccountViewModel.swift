//
//  SelectedAccountViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import Foundation

class SelectedAccountViewModel {
    var controllerType: SelectedType
    
    var accountArray = RealmManager<AccountModel>().read()
    var spendCategory = ["Продукты","Платежи","Развлечения","Женщины"]
    
    init(controllerType: SelectedType) {
        self.controllerType = controllerType
    }
    
}
