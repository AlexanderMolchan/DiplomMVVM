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
        view.backgroundColor = defaultsBackgroundColor
        addTargets()
    }
    
    private func addTargets() {
        contentView.reminderSwitcher.addTarget(self, action: #selector(showPicker), for: .valueChanged)
        contentView.dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        contentView.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
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
        let dateOfReminder = contentView.reminderSwitcher.isOn ? contentView.reminderPicker.date : nil
        let model = DebtModel(debter: name, summ: summ, returnDate: dateOfReturn, notificationDate: dateOfReminder)
        viewModel.writeObjectToRealm(object: model)
        dismissClosure?()
        dismiss(animated: true)
    }

}

extension DebtReminderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
