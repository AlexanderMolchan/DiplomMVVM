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
        field.keyboardType = .numberPad
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
    
    lazy var reminderPickerDate: UIDatePicker = {
        let picker = UIDatePicker()
        picker.alpha = 0
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .defaultsColor
        picker.minimumDate = .now
        return picker
    }()
    
    lazy var reminderPickerTime: UIDatePicker = {
        let picker = UIDatePicker()
        picker.alpha = 0
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .defaultsColor
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
    
    private lazy var reminderDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 17)
        label.textColor = .defaultsColor
        label.alpha = 0
        return label
    }()
    
    private lazy var reminderTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 17)
        label.textColor = .defaultsColor
        label.alpha = 0
        return label
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
        addSubview(reminderPickerDate)
        addSubview(reminderPickerTime)
        addSubview(confirmButton)
        addSubview(dismissButton)
        addSubview(reminderDateLabel)
        addSubview(reminderTimeLabel)
    }
    
    func assignTexts() {
        titleLabel.text = Localization.Debts.title.rawValue.localized()
        debtNameLabel.text = Localization.Debts.debtName.rawValue.localized()
        summLabel.text = Localization.Debts.summLabel.rawValue.localized()
        returnDateLabel.text = Localization.Debts.returnDate.rawValue.localized()
        reminderLabel.text = Localization.Debts.reminderLabel.rawValue.localized()
        reminderDateLabel.text = Localization.Debts.reminderDate.rawValue.localized()
        reminderTimeLabel.text = Localization.Debts.reminderTime.rawValue.localized()
        
        
        confirmButton.setTitle(Localization.CreateEdit.save.rawValue.localized(), for: .normal)
        dismissButton.setTitle(Localization.Settings.alertCancel.rawValue.localized(), for: .normal)
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
        
        reminderPickerDate.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(universalInset)
            make.top.equalTo(reminderLabel.snp.bottom).offset(20)
        }
        
        reminderPickerTime.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(universalInset)
            make.top.equalTo(reminderPickerDate.snp.bottom).offset(20)
        }
        
        reminderDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reminderPickerDate)
            make.leading.equalToSuperview().inset(universalInset)
        }
        
        reminderTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reminderPickerTime)
            make.leading.equalToSuperview().inset(universalInset)
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
                self?.reminderPickerDate.alpha = 1
                self?.reminderPickerTime.alpha = 1
                self?.reminderDateLabel.alpha = 1
                self?.reminderTimeLabel.alpha = 1
            } else {
                self?.reminderPickerDate.alpha = 0
                self?.reminderPickerTime.alpha = 0
                self?.reminderDateLabel.alpha = 0
                self?.reminderTimeLabel.alpha = 0
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
