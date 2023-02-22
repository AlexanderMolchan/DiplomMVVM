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
    @objc dynamic var creationgSumm: Int = 0
    @objc private dynamic var isCreditAccount: Bool = true
    
    var type: AccountType {
        isCreditAccount ? .credit : .cash
    }
    
    var allCashFlows: [CashModel] {
        let allCashModels = RealmManager().read(type: CashModel.self)
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
    
    var currentSumm: Double {
        var summ = Double(creationgSumm)
        spending.forEach { spend in
            summ -= spend.summ
        }
        incoming.forEach { income in
            summ += income.summ
        }
        return summ
    }
    
    convenience init(name: String, creationgSumm: Int, isCreditAccount: Bool) {
        self.init()
        self.id = UUID().uuidString
        self.name = name
        self.creationgSumm = creationgSumm
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
    


class CashModel: Object {
    @objc dynamic var summ: Double = 0.0
    @objc private dynamic var accountTypeRawValue = AccountType.error.rawValue
    @objc private dynamic var cashFlowType = CashFlowType.error.rawValue
    @objc dynamic var category: CashFlowCategory? = CashFlowCategory()
    @objc dynamic var ownerID = ""
    @objc dynamic var date: Date = Date()
    
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
    
    var stringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self.date)
    }
    
    convenience init(summ: Double, accountTypeRawValue: AccountType.RawValue, cashFlowType: CashFlowType.RawValue, category: CashFlowCategory, ownerID: String) {
        self.init()
        self.summ = summ
        self.accountTypeRawValue = accountTypeRawValue
        self.cashFlowType = cashFlowType
        self.category = category
        self.ownerID = ownerID
        self.date = Date.now
    }
    
}

class CashFlowCategory: Object {
    @objc dynamic var name: String = ""
    @objc private dynamic var isSpendingFlow: Bool = true
    
    var type: CashFlowType {
        isSpendingFlow ? .spending : .incoming
    }
    
    convenience init(name: String, isSpendingFlow: Bool) {
        self.init()
        self.name = name
        self.isSpendingFlow = isSpendingFlow
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
