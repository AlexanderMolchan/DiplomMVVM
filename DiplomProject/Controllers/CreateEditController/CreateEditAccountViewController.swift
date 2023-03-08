//
//  CreateEditAccountViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit
import RealmSwift

class CreateEditAccountViewController: BaseViewController {
    private let viewModel: CreateEditViewModel
    var dismissClosure: (() -> Void)?
    
    var contentView: CreateEditAccountViewControllerView {
        self.view as! CreateEditAccountViewControllerView
    }
    
    init(viewModel: CreateEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = CreateEditAccountViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addActions()
    }
    
    private func setupUI() {
        view.backgroundColor = defaultsBackgroundColor
        switch viewModel.controllerType {
            case .create:
                if viewModel.objectType == .account {
                    contentView.titleLabel.text = "Создать новый аккаунт"
                } else {
                    contentView.titleLabel.text = "Создать новую категорию"
                    contentView.hideElements()
                }
            case .edit:
                if viewModel.objectType == .account {
                    contentView.titleLabel.text = "Редактировать аккаунт"
                    guard let doubleSumm = viewModel.currentAccount?.currentSumm,
                          let isCreditAccount = viewModel.currentAccount?.isCreditAccount else { return }
                    contentView.nameField.text = viewModel.currentAccount?.name
                    contentView.summField.text = "\(Int(doubleSumm))"
                    contentView.switcher.isOn = isCreditAccount
                } else {
                    contentView.titleLabel.text = "Редактировать категорию"
                    contentView.nameField.text = viewModel.currentCategory?.name
                    contentView.hideElements()
                }
            default: break
        }
        contentView.nameField.delegate = self
    }
    
    private func addActions() {
        contentView.dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        switch viewModel.objectType {
            case .account:
                contentView.confirmButton.addTarget(self, action: #selector(confirmActionForAccount), for: .touchUpInside)
            case .spendCategory:
                contentView.confirmButton.addTarget(self, action: #selector(confirmActionForCategory), for: .touchUpInside)
        }
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true)
    }
    
    @objc private func confirmActionForAccount() {
        guard !contentView.nameField.text.isEmptyOrNil,
              let name = contentView.nameField.text,
              !repeatedNameCheck(name: name, type: .account) else {
            contentView.emptyFieldAnimation(field: contentView.nameField)
            return
        }
        guard !contentView.summField.text.isEmptyOrNil,
              let summFromField = contentView.summField.text,
              let summ = Double(summFromField) else {
            contentView.emptyFieldAnimation(field: contentView.summField)
            return
        }
        switch viewModel.controllerType {
            case .create:
                viewModel.createAccount(name: name, summ: summ, isCredit: contentView.switcher.isOn)
            case .edit:
                viewModel.updateAccount(name: name, summ: summ, isCredit: contentView.switcher.isOn)
            default: break
        }
        dismissClosure?()
        dismiss(animated: true)
    }
    
    @objc private func confirmActionForCategory() {
        guard !contentView.nameField.text.isEmptyOrNil,
              let name = contentView.nameField.text,
        !repeatedNameCheck(name: name, type: .spendCategory) else {
            contentView.emptyFieldAnimation(field: contentView.nameField)
            return
        }
        switch viewModel.controllerType {
            case .create: viewModel.createCategory(name: name)
            case .edit:   viewModel.updateCategory(name: name)
            default: break
        }
        dismissClosure?()
        dismiss(animated: true)
    }
    
    private func repeatedNameCheck(name: String, type: AccountOrCategoryType) -> Bool {
        let alert = UIAlertController(title: "Такое имя уже существует!", message: "Выберите другое имя.", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Хорошо", style: .cancel)
        alert.addAction(okBtn)
        
        var allNames = [String]()
        var lowerCasedName = String()
        var currentName: String?
        
        switch type {
            case .account:
                 allNames = viewModel.realm.read(type: AccountModel.self).map { account in
                    return account.name.lowercased()
                }
                 lowerCasedName = name.lowercased()
                 currentName = viewModel.currentAccount?.name.lowercased()
            case .spendCategory:
                allNames = viewModel.realm.read(type: CashFlowCategory.self).map { category in
                    return category.name.lowercased()
                }
                lowerCasedName = name.lowercased()
                currentName = viewModel.currentCategory?.name.lowercased()
        }
        
        switch viewModel.controllerType {
            case .edit:
                allNames = allNames.filter({ $0 != currentName })
            default: break
        }
        
        if allNames.contains(lowerCasedName) {
            present(alert, animated: true)
            return true
        } else {
            return false
        }
    }
}

extension CreateEditAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
