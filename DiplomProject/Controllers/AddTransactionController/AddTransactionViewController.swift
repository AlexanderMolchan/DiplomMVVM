//
//  AddTransactionControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

class AddTransactionViewController: UIViewController {
    private let viewModel: AddTransactionViewModel
    
    private var contentView: AddTransactionViewControllerView {
        return self.view as! AddTransactionViewControllerView
    }
    
    init(viewModel: AddTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = AddTransactionViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfigurate()
        addButtonsAction()
        bindElements()
        addSegmentAction()
    }
    
    private func controllerConfigurate() {
        view.backgroundColor = .white
        navigationSettings(title: "Добавить")
    }
    
    private func bindElements() {
        viewModel.cashFieldText.bind { [weak self] text in
            self?.contentView.cashLabel.text = text
        }
        viewModel.selectedAccountName.bind { [weak self] name in
            self?.contentView.selectedAccountTypeButton.setTitle(name ?? "Выберите аккаунт", for: .normal)
        }
        
        viewModel.selectedCategoryName.bind { [weak self] name in
            self?.contentView.selectedSpendCategoryButton.setTitle(name ?? "Категория", for: .normal)
        }
    }
    
    private func addButtonsAction() {
        contentView.oneButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.twoButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.threeButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.fourButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.fiveButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.sixButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.sevenButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.eightButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.nineButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.zeroButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(actionForDeleteButton), for: .touchUpInside)
        contentView.dotButton.addTarget(self, action: #selector(actionForDotButton), for: .touchUpInside)
        contentView.deleteButton.isEnabled = false
        
        contentView.selectedAccountTypeButton.addTarget(self, action: #selector(selectAccount), for: .touchUpInside)
        contentView.selectedSpendCategoryButton.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
        contentView.enterButton.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
    }
    
    @objc private func enterAction() {
        viewModel.transactionCreateError.bind { [weak self] error in
            switch error {
                case .emptyField:
                    self?.emptyFieldError()
                case .unselectedAccount:
                    self?.accountError(button: self?.contentView.selectedAccountTypeButton)
                case .unselectedCategory:
                    self?.categoryError(button: self?.contentView.selectedSpendCategoryButton)
                case .allIsGood:
                    self?.contentView.labelAnimate(subTupe: .fromLeft)
                default: break
            }
        }
        viewModel.enterAction()
        contentView.hapticFeedback()
    }
    
    private func shakeAnimation(button: UIButton?) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.8
        animation.values = [0, -8.0, 8.0, -8.0, 8.0, -8.0, 8.0, 0]
        button?.layer.add(animation, forKey: nil)
    }
    
    private func categoryError(button: UIButton?) {
        shakeAnimation(button: button)
        UIView.animate(withDuration: 0.3) {
            button?.layer.borderColor = UIColor.systemRed.cgColor
            button?.layer.borderWidth = 2
            button?.tintColor = .red
        } completion: { isFinish in
            guard isFinish else { return }
            UIView.animate(withDuration: 0.5) {
                button?.layer.borderColor = UIColor.systemCyan.cgColor
                button?.layer.borderWidth = 2
                button?.tintColor = .systemCyan
            }
        }
    }
    
    private func accountError(button: UIButton?) {
        shakeAnimation(button: button)
        UIView.animate(withDuration: 0.3) {
            button?.tintColor = .red
        } completion: { isFinish in
            guard isFinish else { return }
            UIView.animate(withDuration: 0.5) {
                button?.tintColor = .systemCyan
            }
        }
    }
    
    private func emptyFieldError() {
        let errorLabel = UILabel()
        errorLabel.text = "Введите сумму!"
        errorLabel.alpha = 0
        errorLabel.font = UIFont(name: "Marker Felt", size: 20)
        errorLabel.textColor = .red
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.selectedAccountTypeButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            errorLabel.alpha = 0.77
        } completion: { isFinish in
            guard isFinish else { return }
            UIView.animate(withDuration: 0.3) {
                errorLabel.alpha = 0
            } completion: { isFinish in
                guard isFinish else { return }
                UIView.animate(withDuration: 0.3) {
                    errorLabel.alpha = 0.77
                } completion: { isFinish in
                    guard isFinish else { return }
                    UIView.animate(withDuration: 0.3) {
                        errorLabel.alpha = 0
                    } completion: { isFinish in
                        guard isFinish else { return }
                        errorLabel.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    @objc private func selectAccount() {
        let viewModel = SelectedAccountViewModel(controllerType: .account, cashFlowType: viewModel.cashFlowType)
        let selectedAccountVc = SelectedAccountViewController(viewModel: viewModel)
        selectedAccountVc.nameChangeClosure = { account in
            self.viewModel.selectedAccount = account
        }
        navigationController?.present(selectedAccountVc, animated: true)
    }
    
    @objc private func selectCategory() {
        let viewModel = SelectedAccountViewModel(controllerType: .spendCategory, cashFlowType: viewModel.cashFlowType)
        let selectedCategoryVc = SelectedAccountViewController(viewModel: viewModel)
        selectedCategoryVc.categoryChangeClousure = { category in
            self.viewModel.selectedCategory = category
        }
        selectedCategoryVc.modalPresentationStyle = .pageSheet
        guard let sheet = selectedCategoryVc.sheetPresentationController else { return }
        sheet.detents = [.medium(), .large()]
        navigationController?.present(selectedCategoryVc, animated: true)
    }
    
    @objc private func actionForDeleteButton(sender: UIButton) {
        viewModel.deleteAction()
        contentView.cashLabel.layer.add(contentView.bounceAnimation, forKey: nil)
        sender.layer.add(contentView.bounceAnimation, forKey: nil)
        contentView.hapticFeedback()
        deleteAll()
    }
    
    private func addSegmentAction() {
        contentView.controllerTypeSegmentControl.addTarget(self, action: #selector(segmentChangedValue), for: .valueChanged)
    }
    
    @objc private func segmentChangedValue() {
        switch contentView.controllerTypeSegmentControl.selectedSegmentIndex {
            case 0:
                viewModel.cashFlowType = .spending
                viewModel.selectedCategory = nil
            case 1:
                viewModel.cashFlowType = .incoming
                viewModel.selectedCategory = nil
            default: break
        }
    }
    
    private func deleteAll() {
        let longPressure = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture: )))
        longPressure.minimumPressDuration = 0.75
        contentView.deleteButton.addGestureRecognizer(longPressure)
    }
    
    @objc private func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            viewModel.clearAll()
            contentView.hapticFeedback()
            contentView.labelAnimate(subTupe: .fromRight)
        }
    }
    
    @objc private func actionForButton(sender: UIButton) {
        viewModel.actionButtonIsEnabled.bind { [weak self] enabled in
            self?.contentView.buttonsArray.forEach { button in
                button.isEnabled = enabled
            }
        }
        viewModel.deleteButtonIsEnabled.bind { [weak self] enabled in
            self?.contentView.deleteButton.isEnabled = enabled
        }
        
        var num = ""
        switch sender {
            case contentView.oneButton:         num = "1"
            case contentView.twoButton:         num = "2"
            case contentView.threeButton:       num = "3"
            case contentView.fourButton:        num = "4"
            case contentView.fiveButton:        num = "5"
            case contentView.sixButton:         num = "6"
            case contentView.sevenButton:       num = "7"
            case contentView.eightButton:       num = "8"
            case contentView.nineButton:        num = "9"
            case contentView.zeroButton:        num = "0"
            default: break
        }
        viewModel.buttonAction(number: num)
        
        contentView.cashLabel.layer.add(contentView.bounceAnimation, forKey: nil)
        sender.layer.add(contentView.bounceAnimation, forKey: nil)
        contentView.hapticFeedback()
    }
    
    @objc private func actionForDotButton(sender: UIButton) {
        viewModel.actionForDotButton()
        contentView.cashLabel.layer.add(contentView.bounceAnimation, forKey: nil)
        sender.layer.add(contentView.bounceAnimation, forKey: nil)
        contentView.hapticFeedback()
    }
    
}
