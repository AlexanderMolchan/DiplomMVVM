//
//  CurrencyApi.swift
//  DiplomProject
//
//  Created by Александр Молчан on 21.03.23.
//

import Foundation
import Moya

enum CurrencyApi {
    case getCurrency
}

extension CurrencyApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.nbrb.by/api/exrates/rates")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        guard let parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        switch self {
            case .getCurrency:
                parameters["periodicity"] = "0"
        }
        return parameters
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
}
