//
//  UserDefaults.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import Foundation

class DefaultsManager {
    private static let defaults = UserDefaults.standard
    
    static var firstStart: Bool {
        get {
            defaults.value(forKey: #function) as? Bool ?? true
        } set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    static var selectedColorIndex: Int {
        get {
            defaults.value(forKey: #function) as? Int ?? 0
        } set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    static var isHapticEnabled: Bool {
        get {
            defaults.value(forKey: #function) as? Bool ?? true
        } set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    static var isSummInteger: Bool {
        get {
            defaults.value(forKey: #function) as? Bool ?? true
        } set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
}
