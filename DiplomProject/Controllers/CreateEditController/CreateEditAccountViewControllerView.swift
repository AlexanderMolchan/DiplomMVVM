//
//  CreateEditAccountViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit
import SnapKit

class CreateEditAccountViewControllerView: UIView {
    
    let titleLabel = UILabel()
    let nameLabel = UILabel()
    let nameField = UITextField()
    let summLabel = UILabel()
    let summField = UITextField()
    let messageLabel = UILabel()
    let isCreditOrNotLabel = UILabel()
    let switcher = UISwitch()
    var confirmButton = UIButton()
    var dismissButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configurateUI()
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        titleLabel.font = UIFont(name: "Marker Felt", size: 27)
        titleLabel.textColor = .systemCyan
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        let universalInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        nameLabel.font = UIFont(name: "Marker Felt", size: 20)
        nameLabel.textColor = .systemCyan
        nameLabel.text = "Введите имя аккаунта:"
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).inset(60)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }

        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.systemCyan.cgColor
        nameField.layer.cornerRadius = 10
        nameField.addLeftAndRightView()
        addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(universalInset)
            make.height.equalTo(37)
        }
        
        summLabel.font = UIFont(name: "Marker Felt", size: 20)
        summLabel.textColor = .systemCyan
        summLabel.text = "Введите сумму:"
        addSubview(summLabel)
        summLabel.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        summField.layer.borderWidth = 1
        summField.layer.borderColor = UIColor.systemCyan.cgColor
        summField.layer.cornerRadius = 10
        summField.addLeftAndRightView()
        addSubview(summField)
        summField.snp.makeConstraints { make in
            make.top.equalTo(summLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(universalInset)
            make.height.equalTo(37)
        }
        
        messageLabel.font = UIFont(name: "Chalkboard SE", size: 14)
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.text = "Автоматически будет создан аккаунт с наличными средствами. Для того, чтобы создать безналичный аккаунт, активируйте переключатель."
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(summField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        isCreditOrNotLabel.font = UIFont(name: "Marker Felt", size: 20)
        isCreditOrNotLabel.textColor = .systemCyan
        isCreditOrNotLabel.text = "Безналичный аккаунт:"
        addSubview(isCreditOrNotLabel)
        isCreditOrNotLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(universalInset)
        }
        
        switcher.onTintColor = .systemCyan
        switcher.thumbTintColor = .white
        addSubview(switcher)
        switcher.snp.makeConstraints { make in
            make.centerY.equalTo(isCreditOrNotLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(universalInset)
        }

        
        dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Отмена", for: .normal)
        dismissButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 27)
        dismissButton.tintColor = .systemRed
        dismissButton.backgroundColor = .white
        dismissButton.layer.borderWidth = 2
        dismissButton.layer.borderColor = UIColor.systemRed.cgColor
        dismissButton.layer.cornerRadius = 10
        
        addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(universalInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Сохранить", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 27)
        confirmButton.tintColor = .systemCyan
        confirmButton.backgroundColor = .white
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.borderColor = UIColor.systemCyan.cgColor
        confirmButton.layer.cornerRadius = 10
        
        addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(dismissButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func closeKeyboard() {
        nameField.endEditing(true)
        summField.endEditing(true)
    }
    
}
