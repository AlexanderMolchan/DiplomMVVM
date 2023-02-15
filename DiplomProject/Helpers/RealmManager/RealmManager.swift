//
//  RealmManager.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import Foundation
import RealmSwift

class RealmManager<T> where T: Object {
    private let realm = try? Realm()
    
    func write(object: T) {
        guard let realm else { return }
        try? realm.write {
            realm.add(object)
        }
    }
    
    func read() -> [T] {
        guard let realm else { return [] }
        return Array(realm.objects(T.self))
    }
    
    func update(realmBlock: @escaping (Realm) -> Void) {
        guard let realm else { return }
        realmBlock(realm)
    }
    
    func delete(object: T) {
        guard let realm else { return }
        try? realm.write {
            realm.delete(object)
        }
    }
    
}
