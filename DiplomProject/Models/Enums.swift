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
            case .cash:         return Localization.Models.cash.rawValue.localized()
            case .credit:       return Localization.Models.cashless.rawValue.localized()
            case .error:        return "Error"
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
            case .wallet:   return Localization.EmptyTitle.walletTop.rawValue.localized()
            case .account:  return Localization.EmptyTitle.accTop.rawValue.localized()
            default:        return "Title not found"
        }
    }
    
    var emptyViewMessage: String {
        switch self {
            case .wallet:   return Localization.EmptyTitle.walletBot.rawValue.localized()
            case .account:  return Localization.EmptyTitle.accBot.rawValue.localized()
            default:        return "Message not found"
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
            case .incomeTypes:      return Localization.Settings.incomeTypes.rawValue.localized()
            case .spendTypes:       return Localization.Settings.spendTypes.rawValue.localized()
            case .summFormat:       return Localization.Settings.summFormat.rawValue.localized()
            case .vibrations:       return Localization.Settings.vibrations.rawValue.localized()
            case .chooseColor:      return Localization.Settings.chooseColor.rawValue.localized()
            case .chooseLanguage:   return Localization.Settings.chooseLanguage.rawValue.localized()
            case .currency:         return Localization.Settings.currency.rawValue.localized()
            case .deleteAllData:    return Localization.Settings.deleteAllData.rawValue.localized()
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

// MARK: -
// MARK: - Localization Enum

enum LanguageType: CaseIterable {
    case ru
    case en
    
    var languageCode: String {
        switch self {
            case .ru: return "ru"
            case .en: return "en"
        }
    }
    
    var title: String {
        switch self {
            case .ru: return "Русский"
            case .en: return "English"
        }
    }
}

enum Localization {}

extension Localization {
    enum Settings: String {
        case title = "settings.title"
        case incomeTypes = "settings.income"
        case spendTypes = "settings.spend"
        case summFormat = "settings.summFormat"
        case vibrations = "settings.vibrations"
        case chooseColor = "settings.colors"
        case chooseLanguage = "settings.language"
        case currency = "settings.currency"
        case deleteAllData = "settings.deleteAll"
        case alertCancel = "settings.alertCancel"
        case alertConfirm = "settings.alertConfirm"
        case deleteAllTitle = "settings.deleteAllTitle"
        case deleteAllMessage = "settings.deleteAllMessage"
        case languageTitle = "settings.languageTitle"
        case languageMessage = "settings.languageMessage"
    }
}

extension Localization {
    enum Flows: String {
        case emptyAccTop = "flow.emptyAccTop"
        case emptyAccBot = "flow.emptyAccBot"
        case emptyFlowTop = "flow.emptyFlowTop"
        case emptyFlowBot = "flow.emptyFlowBot"
        case deleteTitle = "flow.deleteTitle"
        case deleteMessageOne = "flow.deleteMessageOne"
        case deleteMessageTwo = "flow.deleteMessageTwo"
        case createTitle = "flow.createTitle"
        case menuTitle = "flow.menuTitle"
        case edit = "flow.edit"
        case delete = "flow.delete"
    }
}

extension Localization {
    enum CreateEdit: String {
        case accName = "create.accName"
        case accSumm = "create.accSumm"
        case message = "create.message"
        case accType = "create.accType"
        case save = "create.save"
        case categoryName = "create.categoryName"
        case newAcc = "create.newAcc"
        case newCat = "create.newCategory"
        case editAcc = "create.editAcc"
        case editCat = "create.editCategory"
        case alertTitle = "create.nameAlertTitle"
        case alertMessage = "create.nameAlertMessage"
        case fine = "create.good"
    }
}

extension Localization {
    enum CurrencyTitles: String {
        case emptyTop = "currency.emptyTop"
        case emptyBot = "currency.emptyBot"
    }
}

extension Localization {
    enum Debts: String {
        case title = "debt.title"
        case debtName = "debt.debtName"
        case summLabel = "debt.summ"
        case returnDate = "debt.returnDate"
        case reminderLabel = "debt.remindeLabel"
        case reminderDate = "debt.reminderDate"
        case reminderTime = "debt.reminderTime"
        case alertTitle = "debt.alertTitle"
        case alertMessage = "debt.alertMessage"
        case done = "debt.done"
        case emptyTop = "debt.emptyTop"
        case emptyBot = "debt.emptyBot"
        case navTitle = "debt.navTitle"
        case menuTitle = "debt.menuTitle"
        case cellReturnDate = "debt.cellReturnDate"
        case cellReminderDate = "debt.cellReminderDate"
        case mainLabel = "debt.cellMainLabel"
    }
}

extension Localization {
    enum Analytics: String {
        case totalIncome = "analytics.totalIncome"
        case totalSpend = "analytics.totalSpend"
        case dailyIncome = "analytics.incomePerDay"
        case dailySpend = "analytics.spendPerDay"
        case flowsCount = "analytics.flowsCount"
        case allIncome = "analytics.allIncome"
        case allSpend = "analytics.allSpend" 
    }
}

extension Localization {
    enum Models: String {
        case cash = "account.cash"
        case cashless = "account.cashless"
    }
}

extension Localization {
    enum Wallet: String {
        case navTitle = "wallet.navTitle"
        case totalSumm = "wallet.totalSumm"
        case currentSumm = "wallet.currentSumm"
        case accDeleteTitle = "wallet.deleteAccountAlert"
        case accDeleteMessage = "wallet.deleteAccountMessage"
        case flowDeleteTitle = "wallet.deleteFlowsAlert"
        case flowDeleteMessage = "wallet.deleteFlowsMessage"
        case menuAccCreate = "menu.accCreate"
        case sortByName = "menu.sortByName"
        case sortBySumm = "menu.sortBySumm"
        case sortTitle = "menu.sortTitle"
        case accEdit = "menu.accEdit"
        case accDelete = "menu.accDelete"
        case flowsDelete = "menu.flowsDelete"
    }
}

extension Localization {
    enum EmptyTitle: String {
        case walletTop = "empty.walletTop"
        case walletBot = "empty.walletBot"
        case accTop = "empty.accTop"
        case accBot = "empty.accBot"
        case cardTop = "empty.cardTop"
        case cardBot = "empty.cardBot"
        case emptyAccs = "empty.emptyAccounts"
    }
}

extension Localization {
    enum AddController: String {
        case chooseAccount = "add.chooseAccount"
        case cooseCategory = "add.chooseCategory"
        case segmentIncome = "add.segmentIncome"
        case segmentSpend = "add.segmentSpend"
        case enterSum = "add.enterSum"
        case addNavTitle = "add.addNavTitle"
        case enterButtonTitle = "add.enterButton"
    }
}

extension Localization {
    enum TabBarTitle: String, CaseIterable {
        case add = "tabbar.add"
        case wallet = "tabbar.wallet"
        case analytics = "tabbar.analytics"
        case debts = "tabbar.debts"
        case settings = "tabbar.settings"
    }
}

