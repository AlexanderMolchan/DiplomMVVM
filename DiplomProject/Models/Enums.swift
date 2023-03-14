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

enum AccountOrCategoryType {
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
    case choose
    case wallet
    case account
    
    var emptyViewTitle: String {
        switch self {
            case .wallet:   return "У вас нет активных счетов."
            case .account:  return "На данном счете нет транзакций."
            default:        return "Title not found"
        }
    }
    
    var emptyViewMessage: String {
        switch self {
            case .wallet:   return "Создайте новые счета, и они будут отображаться здесь."
            case .account:  return "Добавьте транзакции, чтобы они отображались здесь."
            default:        return "Message not found"
        }
    }
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
    case currency
    case deleteAllData
    
    var title: String {
        switch self {
            case .incomeTypes:      return "Категории доходов"
            case .spendTypes:       return "Категории расходов"
            case .summFormat:       return "Целые числа"
            case .vibrations:       return "Виброотклик"
            case .chooseColor:      return "Цвет оформления"
            case .chooseLanguage:   return "Язык"
            case .currency:         return "Курс валюты"
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
            case .currency:         return UIImage(systemName: "atom")
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
            case .currency:         return false
            case .deleteAllData:    return false
        }
    }
}

enum TintColorEnum: CaseIterable {
    case cyan
    case magenta
    case black
    case green
    case orange
    case pink
    case blue
    case brown
    case lightGray
    case mint
    case indigo
    case purple
    
    var color: UIColor {
        switch self {
            case .cyan:      return .systemCyan
            case .magenta:   return .magenta
            case .black:     return .black
            case .green:     return .systemGreen
            case .orange:    return .orange
            case .pink :     return .systemPink
            case .blue:      return .blue
            case .brown:     return .brown
            case .lightGray: return .lightGray
            case .mint:      return .systemMint
            case .indigo:    return .systemIndigo
            case .purple:    return .systemPurple
        }
    }
}
