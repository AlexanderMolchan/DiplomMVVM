//
//  Models.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import Foundation
import RealmSwift

class AccountModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var name: String = ""
    @objc dynamic var sum: Int = 0
    @objc private dynamic var isCreditAccount: Bool = true
    
    var type: AccountType {
        isCreditAccount ? .credit : .cash
    }
    
    var allCashFlows: [CashModel] {
        let allCashModels = RealmManager<CashModel>().read()
        let accountCashModels = allCashModels.filter({ $0.ownerID == self.id })
        return accountCashModels
    }
    
    var spending: [CashModel] {
        let accountSpending = allCashFlows.filter({ $0.cashFlow == .spending })
        return accountSpending
    }
    
    var incoming: [CashModel] {
        let accountIncoming = allCashFlows.filter({ $0.cashFlow == .incoming })
        return accountIncoming
    }
    
    convenience init(name: String, sum: Int, isCreditAccount: Bool) {
        self.init()
        self.id = UUID().uuidString
        self.name = name
        self.sum = sum
        self.isCreditAccount = isCreditAccount
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

enum SpendCategory: CaseIterable {
    case food
    case bills
    case cars
    
    var name: String {
        switch self {
            case .food:
                return "Еда"
            case .bills:
                return "Платежи"
            case .cars:
                return "Транспорт"
        }
    }
    
}

class CashModel: Object {
    @objc dynamic var summ: Double = 0.0
    @objc private dynamic var accountTypeRawValue = AccountType.error.rawValue
    @objc private dynamic var cashFlowType = CashFlowType.error.rawValue
    @objc dynamic var ownerID = ""
    
    var accountType: AccountType {
        get {
            return AccountType(rawValue: accountTypeRawValue) ?? .error
        } set {
            return accountTypeRawValue = newValue.rawValue
        }
    }
    
    var cashFlow: CashFlowType {
        get {
            return CashFlowType(rawValue: cashFlowType) ?? .error
        } set {
            return cashFlowType = newValue.rawValue
        }
    }
    
    convenience init(summ: Double, accountTypeRawValue: AccountType.RawValue, cashFlowType: CashFlowType.RawValue, ownerID: String) {
        self.init()
        self.summ = summ
        self.accountTypeRawValue = accountTypeRawValue
        self.cashFlowType = cashFlowType
        self.ownerID = ownerID
    }
    
}

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

enum SelectedType {
    case account
    case spendCategory
}
