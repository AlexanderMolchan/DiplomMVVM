//
//  CreateEditViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import Foundation

class CreateEditViewModel {
    var currentAccount: AccountModel?
    var controllerType: ControllerType
    
    init(currentAccount: AccountModel? = nil, controllerType: ControllerType) {
        self.currentAccount = currentAccount
        self.controllerType = controllerType
    }
    
}

enum ControllerType {
    case edit
    case create
}
