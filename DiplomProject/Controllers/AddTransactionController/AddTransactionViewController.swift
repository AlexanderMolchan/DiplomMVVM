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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        invalidateCheck()
        bindElements()
    }
    
    private func invalidateCheck() {
        viewModel.accountInvalidatedCheck()
        viewModel.categoryInvalidatedCheck()
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
                    self?.contentView.emptyFieldError()
                case .unselectedAccount:
                    self?.contentView.accountError()
                case .unselectedCategory:
                    self?.contentView.categoryError()
                case .allIsGood:
                    self?.contentView.labelAnimate(subTupe: .fromLeft)
                default: break
            }
        }
        viewModel.enterAction()
        contentView.hapticFeedback()
    }
    
    @objc private func selectAccount() {
        let viewModel = SelectedAccountViewModel(controllerType: .account, cashFlowType: viewModel.cashFlowType, realm: viewModel.realm)
        let selectedAccountVc = SelectedAccountViewController(viewModel: viewModel)
        selectedAccountVc.nameChangeClosure = { account in
            self.viewModel.selectedAccount = account
        }
        navigationController?.present(selectedAccountVc, animated: true)
    }
    
    @objc private func selectCategory() {
        let viewModel = SelectedAccountViewModel(controllerType: .spendCategory, cashFlowType: viewModel.cashFlowType, realm: viewModel.realm)
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
