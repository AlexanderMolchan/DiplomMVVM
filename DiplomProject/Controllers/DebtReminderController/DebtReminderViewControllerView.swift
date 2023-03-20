//
//  DebtReminderViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 20.03.23.
//

import UIKit
import SnapKit

final class DebtReminderViewControllerView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 24)
        label.textColor = .defaultsColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var debtNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 17)
        label.textColor = .defaultsColor
        return label
    }()
    
    lazy var debtNameField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.defaultsColor.cgColor
        field.layer.cornerRadius = 10
        field.addLeftAndRightView()
        return field
    }()
    
    private lazy var summLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 17)
        label.textColor = .defaultsColor
        return label
    }()
    
    lazy var summField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.defaultsColor.cgColor
        field.layer.cornerRadius = 10
        field.addLeftAndRightView()
        return field
    }()
    
    private lazy var returnDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 17)
        label.textColor = .defaultsColor
        return label
    }()
    
    lazy var returnDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .defaultsColor
        picker.minimumDate = .now
        return picker
    }()
    
    private lazy var reminderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 17)
        label.textColor = .defaultsColor
        return label
    }()
    
    lazy var reminderSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = .defaultsColor
        switcher.thumbTintColor = .white
        return switcher
    }()
    
    lazy var reminderPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.alpha = 0
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.tintColor = .defaultsColor
        picker.minimumDate = .now
        return picker
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 27)
        button.tintColor = .defaultsColor
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.defaultsColor.cgColor
        button.layer.cornerRadius = 10
        return button
    }()

    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 27)
        button.tintColor = .systemRed
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateView() {
        layoutElements()
        assignTexts()
        makeConstraints()
        addTapGesture()
    }
    
    private func layoutElements() {
        addSubview(titleLabel)
        addSubview(debtNameLabel)
        addSubview(debtNameField)
        addSubview(summLabel)
        addSubview(summField)
        addSubview(returnDateLabel)
        addSubview(returnDatePicker)
        addSubview(reminderLabel)
        addSubview(reminderSwitcher)
        addSubview(reminderPicker)
        addSubview(confirmButton)
        addSubview(dismissButton)
    }
    
    private func assignTexts() {
        titleLabel.text = "Создать напоминание о возврате:"
        debtNameLabel.text = "Введите название:"
        summLabel.text = "Введите сумму возврата:"
        returnDateLabel.text = "Укажите дату возврата:"
        reminderLabel.text = "Создать напоминание:"
        confirmButton.setTitle("Сохранить", for: .normal)
        dismissButton.setTitle("Отмена", for: .normal)
    }
    
    private func makeConstraints() {
        let universalInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        debtNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).inset(60)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        debtNameField.snp.makeConstraints { make in
            make.top.equalTo(debtNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(universalInset)
            make.height.equalTo(37)
        }
        
        summLabel.snp.makeConstraints { make in
            make.top.equalTo(debtNameField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        summField.snp.makeConstraints { make in
            make.top.equalTo(summLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(universalInset)
            make.height.equalTo(37)
        }
        
        returnDateLabel.snp.makeConstraints { make in
            make.top.equalTo(summField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        returnDatePicker.snp.makeConstraints { make in
            make.centerY.equalTo(returnDateLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(universalInset)
        }
        
        reminderLabel.snp.makeConstraints { make in
            make.top.equalTo(returnDateLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(universalInset)
        }
        
        reminderSwitcher.snp.makeConstraints { make in
            make.centerY.equalTo(reminderLabel)
            make.trailing.equalToSuperview().inset(universalInset)
        }
        
        reminderPicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(reminderLabel).inset(40)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(universalInset)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
        
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
        debtNameField.endEditing(true)
        summField.endEditing(true)
    }
    
    // MARK: -
    // MARK: - Animations
    
    func animatedPicker(show: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if show {
                self?.reminderPicker.alpha = 1
            } else {
                self?.reminderPicker.alpha = 0
            }
        }
    }
    
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
