//
//  Enums.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit

// MARK: -
// MARK: - Model ENUMs

enum CashFlowType: String {
    case spending
    case incoming
    case error
    
    var name: String {
        switch self {
            case .spending:     return "Расходы"
            case .incoming:     return "Доходы"
            case .error:        return "Ошибка"
        }
    }
}

enum AccountType: String {
    case cash
    case credit
    case error
    
    var name: String {
        switch self {
            case .cash:         return "Наличные"
            case .credit:       return "Кредитная карта"
            case .error:        return "Ошибка"
        }
    }
}

// MARK: -
// MARK: - Controller ENUMs

enum SelectedType {
    case account
    case spendCategory
}

enum ErrorTypeEnum {
    case emptyField
    case emptySecondField
    case unselectedAccount
    case unselectedCategory
    case allIsGood
}

enum ControllerType {
    case edit
    case create
}

// MARK: -
// MARK: - Settings ENUM

enum SettingsEnum: CaseIterable {
    case incomeTypes
    case spendTypes
    case summFormat
    case vibrations
    case chooseColor
    case chooseLanguage
    case deleteAllData
    
    var title: String {
        switch self {
            case .incomeTypes:      return "Категории доходов"
            case .spendTypes:       return "Категории расходов"
            case .summFormat:       return "Два знака после запятой"
            case .vibrations:       return "Виброотклик"
            case .chooseColor:      return "Цвет оформления"
            case .chooseLanguage:   return "Язык"
            case .deleteAllData:    return "Удалить все данные"
        }
    }
    
    var image: UIImage? {
        switch self {
            case .incomeTypes:      return UIImage(systemName: "list.clipboard.fill")
            case .spendTypes:       return UIImage(systemName: "list.bullet.clipboard")
            case .summFormat:       return UIImage(systemName: "divide.square")
            case .vibrations:       return UIImage(systemName: "waveform.path")
            case .chooseColor:      return UIImage(systemName: "paintpalette")
            case .chooseLanguage:   return UIImage(systemName: "globe.europe.africa")
            case .deleteAllData:    return UIImage(systemName: "trash.square")
        }
    }
    
    var switchEnabled: Bool {
        switch self {
            case .incomeTypes:      return false
            case .spendTypes:       return false
            case .summFormat:       return true
            case .vibrations:       return true
            case .chooseColor:      return false
            case .chooseLanguage:   return false
            case .deleteAllData:    return false
        }
    }
}
