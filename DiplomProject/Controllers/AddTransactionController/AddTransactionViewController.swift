//
//  AddTransactionControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

class AddTransactionViewController: BaseViewController {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        invalidateCheck()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contentView.removeErrorLabel()
    }
    
    private func invalidateCheck() {
        viewModel.accountInvalidatedCheck()
        viewModel.categoryInvalidatedCheck()
    }
    
    private func controllerConfigurate() {
        view.backgroundColor = defaultsBackgroundColor
        navigationSettings(title: "Добавить")
        deleteAll(sender: contentView.deleteButton)
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
        
        viewModel.actionButtonIsEnabled.bind { [weak self] enabled in
            self?.contentView.buttonsArray.forEach { button in
                button.isEnabled = enabled
            }
        }
        
        viewModel.deleteButtonIsEnabled.bind { [weak self] enabled in
            self?.contentView.deleteButton.isEnabled = enabled
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
        contentView.dotButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        
        contentView.controllerTypeSegmentControl.addTarget(self, action: #selector(segmentChangedValue), for: .valueChanged)
        contentView.selectedAccountTypeButton.addTarget(self, action: #selector(selectAccount), for: .touchUpInside)
        contentView.selectedSpendCategoryButton.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
        contentView.enterButton.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
    }
    
    private func deleteAll(sender: UIButton) {
        let longPressure = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPressure.minimumPressDuration = 0.75
        sender.addGestureRecognizer(longPressure)
    }
    
    @objc private func actionForButton(sender: UIButton) {
        switch sender {
            case contentView.oneButton:         viewModel.buttonAction(number: "1")
            case contentView.twoButton:         viewModel.buttonAction(number: "2")
            case contentView.threeButton:       viewModel.buttonAction(number: "3")
            case contentView.fourButton:        viewModel.buttonAction(number: "4")
            case contentView.fiveButton:        viewModel.buttonAction(number: "5")
            case contentView.sixButton:         viewModel.buttonAction(number: "6")
            case contentView.sevenButton:       viewModel.buttonAction(number: "7")
            case contentView.eightButton:       viewModel.buttonAction(number: "8")
            case contentView.nineButton:        viewModel.buttonAction(number: "9")
            case contentView.zeroButton:        viewModel.buttonAction(number: "0")
            case contentView.dotButton:         viewModel.actionForDotButton()
            case contentView.deleteButton:      viewModel.deleteAction()
            default: break
        }
        contentView.cashLabel.layer.add(contentView.bounceAnimation, forKey: nil)
        sender.layer.add(contentView.bounceAnimation, forKey: nil)
        contentView.removeErrorLabel()
        contentView.hapticFeedback()
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
    
    @objc private func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            viewModel.clearAll()
            contentView.hapticFeedback()
            contentView.labelAnimate(subTupe: .fromRight)
        }
    }
    
    @objc private func selectAccount() {
        let viewModel = SelectedAccountViewModel(controllerType: .account, controllerSubType: .choose, cashFlowType: viewModel.cashFlowType, realm: viewModel.realm)
        let selectedAccountVc = SelectedAccountViewController(viewModel: viewModel)
        contentView.hapticFeedback()
        selectedAccountVc.nameChangeClosure = { account in
            self.viewModel.selectedAccount = account
        }
        navigationController?.present(selectedAccountVc, animated: true)
    }
    
    @objc private func selectCategory() {
        let viewModel = SelectedAccountViewModel(controllerType: .spendCategory, controllerSubType: .choose, cashFlowType: viewModel.cashFlowType, realm: viewModel.realm)
        let selectedCategoryVc = SelectedAccountViewController(viewModel: viewModel)
        contentView.hapticFeedback()
        selectedCategoryVc.categoryChangeClousure = { category in
            self.viewModel.selectedCategory = category
        }
        selectedCategoryVc.modalPresentationStyle = .pageSheet
        guard let sheet = selectedCategoryVc.sheetPresentationController else { return }
        sheet.detents = [.medium(), .large()]
        navigationController?.present(selectedCategoryVc, animated: true)
    }
    
    @objc private func segmentChangedValue() {
        contentView.hapticFeedback()
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
    
}
