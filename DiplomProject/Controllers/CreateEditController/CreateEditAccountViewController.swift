//
//  CreateEditAccountViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit

class CreateEditAccountViewController: UIViewController {
    let viewModel: CreateEditViewModel
    
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
    }
    
    private func setupUI() {
        switch viewModel.controllerType {
            case .create: contentView.titleLabel.text = "Создать новый аккаунт"
            case .edit:   contentView.titleLabel.text = "Редактировать аккаунт"
        }
        contentView.summField.delegate = self
        contentView.nameField.delegate = self
    }
}

extension CreateEditAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
