//
//  DebtReminderViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 20.03.23.
//

import UIKit

final class DebtReminderViewController: BaseViewController {
    private let viewModel: DebtReminderViewModel
    var dismissClosure: (() -> Void)?

    private var contentView: DebtReminderViewControllerView {
        self.view as! DebtReminderViewControllerView
    }

    init(viewModel: DebtReminderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = DebtReminderViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateViewController()
    }
    
    private func configurateViewController() {
        NotificationManager().checkNotificationStatus(denied: { [weak self] in
            self?.showNotificationsAlert()
        })
        view.backgroundColor = defaultsBackgroundColor
        addTargets()
    }
    
    private func addTargets() {
        contentView.reminderSwitcher.addTarget(self, action: #selector(showPicker), for: .valueChanged)
        contentView.dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        contentView.debtNameField.delegate = self
    }
    
    @objc private func showPicker(sender: UISwitch) {
        contentView.animatedPicker(show: sender.isOn)
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true)
    }
    
    @objc private func confirmAction() {
        guard !contentView.debtNameField.text.isEmptyOrNil,
              let name = contentView.debtNameField.text else {
            contentView.emptyFieldAnimation(field: contentView.debtNameField)
            return
        }
        guard !contentView.summField.text.isEmptyOrNil,
              let summFromField = contentView.summField.text,
              let summ = Double(summFromField) else {
            contentView.emptyFieldAnimation(field: contentView.summField)
            return
        }
        let dateOfReturn = contentView.returnDatePicker.date
        let remindeDate = contentView.reminderPickerDate.date
        let remindeTime = contentView.reminderPickerTime.date
        let dateOfReminder = contentView.reminderSwitcher.isOn ? combine(date: remindeDate, time: remindeTime) : nil
     
        let model = DebtModel(debter: name, summ: summ, returnDate: dateOfReturn, notificationDate: dateOfReminder)
        viewModel.writeObjectToRealm(object: model)
        dismissClosure?()
        dismiss(animated: true)
    }
    
    private func combine(date: Date, time: Date) -> Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        var newComponents = DateComponents()
        newComponents.timeZone = .current
        newComponents.day = dateComponents.day
        newComponents.month = dateComponents.month
        newComponents.year = dateComponents.year
        newComponents.hour = timeComponents.hour
        newComponents.minute = timeComponents.minute
        newComponents.second = timeComponents.second
        return calendar.date(from: newComponents)
    }
    
    private func showNotificationsAlert() {
        let alert = UIAlertController(title: "Уведомления запрещены.", message: "Перейдите в настройки, чтобы разрешить допуск уведомлений.", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Понятно", style: .default)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }

}

extension DebtReminderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
