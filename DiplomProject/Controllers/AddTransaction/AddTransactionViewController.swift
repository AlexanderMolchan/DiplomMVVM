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
        bindLabel()
    }
    
    private func controllerConfigurate() {
        view.backgroundColor = .white
        navigationSettings(title: "Добавить")
    }
    
    private func bindLabel() {
        viewModel.cashFieldText.bind { [weak self] text in
            self?.contentView.cashLabel.text = text
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
    }
    
    @objc private func actionForDeleteButton(sender: UIButton) {
        viewModel.deleteAction()
        contentView.cashLabel.layer.add(contentView.bounceAnimation, forKey: nil)
        sender.layer.add(contentView.bounceAnimation, forKey: nil)
        contentView.hapticFeedback()
        deleteAll()
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
