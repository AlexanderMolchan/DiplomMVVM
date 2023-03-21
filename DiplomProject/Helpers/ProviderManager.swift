//
//  ProviderManager.swift
//  DiplomProject
//
//  Created by Александр Молчан on 21.03.23.
//

import Foundation
import Moya

typealias ObjectBlock<T: Decodable> = ((T) -> Void)
typealias ArrayBlock<T: Decodable> = (([T]) -> Void)
typealias Failure = ((Error) -> Void)

final class ProviderManager {
    let provider = MoyaProvider<CurrencyApi>(plugins: [NetworkLoggerPlugin()])
    
    func getCurrency(success: ArrayBlock<CurrencyModel>?, failure: Failure?) {
        provider.request(.getCurrency) { result in
            switch result {
                case .success(let response):
                    do {
                        let data = try JSONDecoder().decode([CurrencyModel].self, from: response.data)
                        success?(data)
                    } catch let error {
                        failure?(error)
                    }
                case .failure(let error):
                    failure?(error)
            }
        }
    }
    
}
