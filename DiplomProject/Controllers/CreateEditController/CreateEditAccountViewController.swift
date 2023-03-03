//
//  CreateEditAccountViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit

class CreateEditAccountViewController: UIViewController {
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
        switch viewModel.controllerType {
            case .create:
                contentView.titleLabel.text = "Создать новый аккаунт"
            case .edit:
                contentView.titleLabel.text = "Редактировать аккаунт"
                guard let doubleSumm = viewModel.currentAccount?.currentSumm,
                      let isCreditAccount = viewModel.currentAccount?.isCreditAccount else { return }
                contentView.nameField.text = viewModel.currentAccount?.name
                contentView.summField.text = "\(Int(doubleSumm))"
                contentView.switcher.isOn = isCreditAccount
        }
        contentView.nameField.delegate = self
    }
    
    private func addActions() {
        contentView.dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true)
    }
    
    @objc private func confirmAction() {
        guard !contentView.nameField.text.isEmptyOrNil,
              let name = contentView.nameField.text,
              !repeatedNameCheck(name: name) else {
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
        }
        dismissClosure?()
        dismiss(animated: true)
    }
    
    private func repeatedNameCheck(name: String) -> Bool {
        let alert = UIAlertController(title: "Счет с таким именем уже существует!", message: "Выберите другое имя.", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Хорошо", style: .cancel)
        alert.addAction(okBtn)
        
        var accauntNames = viewModel.realm.read(type: AccountModel.self).map { account in
            return account.name.lowercased()
        }
        let lowerCasedName = name.lowercased()
        let currentNameLowerCased = viewModel.currentAccount?.name.lowercased()
        
        switch viewModel.controllerType {
            case .edit:
                accauntNames = accauntNames.filter({ $0 != currentNameLowerCased })
            default: break
        }
        
        if accauntNames.contains(lowerCasedName) {
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
