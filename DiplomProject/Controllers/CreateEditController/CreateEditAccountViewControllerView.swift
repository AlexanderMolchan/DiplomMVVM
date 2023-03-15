//
//  CreateEditAccountViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit
import SnapKit

final class CreateEditAccountViewControllerView: UIView {
    private let nameLabel = UILabel()
    private let summLabel = UILabel()
    private let messageLabel = UILabel()
    private let isCreditOrNotLabel = UILabel()
    
    let titleLabel = UILabel()
    let nameField = UITextField()
    let summField = UITextField()
    let switcher = UISwitch()
    var confirmButton = UIButton()
    var dismissButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        titleLabel.font = UIFont(name: "Marker Felt", size: 27)
        titleLabel.textColor = .defaultsColor
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        let universalInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        nameLabel.font = UIFont(name: "Marker Felt", size: 20)
        nameLabel.textColor = .defaultsColor
        nameLabel.text = "Введите имя аккаунта:"
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).inset(60)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.defaultsColor.cgColor
        nameField.layer.cornerRadius = 10
        nameField.addLeftAndRightView()
        addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(universalInset)
            make.height.equalTo(37)
        }
        
        summLabel.font = UIFont(name: "Marker Felt", size: 20)
        summLabel.textColor = .defaultsColor
        summLabel.text = "Введите сумму:"
        addSubview(summLabel)
        summLabel.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        summField.layer.borderWidth = 1
        summField.layer.borderColor = UIColor.defaultsColor.cgColor
        summField.layer.cornerRadius = 10
        summField.keyboardType = .numberPad
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
        isCreditOrNotLabel.textColor = .defaultsColor
        isCreditOrNotLabel.text = "Безналичный аккаунт:"
        addSubview(isCreditOrNotLabel)
        isCreditOrNotLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(universalInset)
        }
        
        switcher.onTintColor = .defaultsColor
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
        confirmButton.tintColor = .defaultsColor
        confirmButton.backgroundColor = .white
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.borderColor = UIColor.defaultsColor.cgColor
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
    
    func hideElements() {
        summLabel.isHidden = true
        summField.isHidden = true
        messageLabel.isHidden = true
        isCreditOrNotLabel.isHidden = true
        switcher.isHidden = true
        nameLabel.text = "Введите имя категории:"
    }
    
    // MARK: -
    // MARK: - Animations
    
    func emptyFieldAnimation(field: UITextField?) {
        guard let field else { return }
        errorFeedback()
        shakeAnimation(view: field)
        UIView.animate(withDuration: 0.3) {
            field.layer.borderColor = UIColor.systemRed.cgColor
            field.layer.borderWidth = 2
        } completion: { isFinish in
            guard isFinish else { return }
            UIView.animate(withDuration: 0.5) {
                field.layer.borderColor = UIColor.defaultsColor.cgColor
                field.layer.borderWidth = 1
            }
        }
    }
    
    private func shakeAnimation(view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.8
        animation.values = [0, -10.0, 10.0, -10.0, 10.0, -10.0, 10.0, 0]
        view.layer.add(animation, forKey: nil)
    }
    
    private func errorFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
}
