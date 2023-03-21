//
//  CurrencyViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 21.03.23.
//

import Foundation

final class CurrencyViewModel {
    let provider: ProviderManager
    var currencyArray = [CurrencyModel]()
    
    init(provider: ProviderManager) {
        self.provider = provider
    }
    
    func formatArray() {
        var newArray = [CurrencyModel]()
        guard let usd = currencyArray.first(where: {$0.name == "USD"}),
              let euro = currencyArray.first(where: {$0.name == "EUR"}),
              let zlt = currencyArray.first(where: {$0.name == "PLN"}),
              let cny = currencyArray.first(where: {$0.name == "CNY"}),
              let rub = currencyArray.first(where: {$0.name == "RUB"}),
              let kzt = currencyArray.first(where: {$0.name == "KZT"}) else { return }
        newArray.append(usd)
        newArray.append(euro)
        newArray.append(zlt)
        newArray.append(cny)
        newArray.append(rub)
        newArray.append(kzt)

        currencyArray = newArray
    }

}
