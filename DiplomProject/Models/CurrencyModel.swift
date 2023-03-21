//
//  CurrencyModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 21.03.23.
//

import Foundation

struct CurrencyModel: Decodable {
    var name: String
    var rate: Double
    var scale: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "Cur_Abbreviation"
        case rate = "Cur_OfficialRate"
        case scale = "Cur_Scale"
    }
}
