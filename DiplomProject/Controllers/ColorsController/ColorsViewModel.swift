//
//  ColorsViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 8.03.23.
//

import Foundation

final class ColorsViewModel {
    var colorsArray = TintColorEnum.allCases
    var selectedIndex = IndexPath(row: DefaultsManager.selectedColorIndex, section: 0)
}
