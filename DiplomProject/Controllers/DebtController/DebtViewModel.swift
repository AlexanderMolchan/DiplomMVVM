//
//  DebtViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import Foundation

final class DebtViewModel {
    let realm: RealmManager
    var debtArray = [DebtModel]()
    
    init(realm: RealmManager) {
        self.realm = realm
    }
    
    func getData() {
        debtArray = realm.read(type: DebtModel.self)
    }
    
    func saveDebt(debt: DebtModel) {
        realm.write(object: debt)
    }
    
    func deleteElementFromRealmAt(indexPath: IndexPath) {
        let objectForDelete = debtArray[indexPath.row]
        realm.delete(object: objectForDelete)
        getData()
    }
    
}
