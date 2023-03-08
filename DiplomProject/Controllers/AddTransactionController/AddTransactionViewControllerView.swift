//
//  AddTransactionViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import UIKit
import SnapKit
import DeviceKit

class AddTransactionViewControllerView: UIView {
    
    var oneButton = UIButton()
    var twoButton = UIButton()
    var threeButton = UIButton()
    var fourButton = UIButton()
    var fiveButton = UIButton()
    var sixButton = UIButton()
    var sevenButton = UIButton()
    var eightButton = UIButton()
    var nineButton = UIButton()
    var zeroButton = UIButton()
    var dotButton = UIButton()
    var deleteButton = UIButton()
    var enterButton = UIButton()
    var selectedSpendCategoryButton = UIButton()
    var selectedAccountTypeButton = UIButton()
    var controllerTypeSegmentControl = UISegmentedControl()
    let cashLabel = UILabel()
    let errorLabel = UILabel()
    
    private let mainStack = UIStackView()
    private let firstButtonStack = UIStackView()
    private let secondButtonStack = UIStackView()
    private let thirdButtonStack = UIStackView()
    private let fourButtonStack = UIStackView()
    private let bottomStack = UIStackView()
    
    var buttonsArray = [UIButton]()
    
    var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.05, 0.95, 1.0]
        bounceAnimation.duration = 0.35
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        stackViewsSettings()
        buttonsSettings()
        labelSettings()
        segmentControlSettings()
    }
    
    private func stackViewsSettings() {
        addSubview(bottomStack)
        bottomStack.axis = .horizontal
        bottomStack.spacing = 10
        bottomStack.distribution = .fillEqually
        bottomStack.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        addSubview(mainStack)
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.distribution = .fillEqually
        mainStack.snp.makeConstraints { make in
            make.bottom.equalTo(bottomStack.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        addToMainStack(stack: fourButtonStack)
        addToMainStack(stack: thirdButtonStack)
        addToMainStack(stack: secondButtonStack)
        addToMainStack(stack: firstButtonStack)
    }
    
    private func addToMainStack(stack: UIStackView) {
        mainStack.addArrangedSubview(stack)
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
    }
    
    private func buttonsSettings() {
        dotButton = setButtonWith(title: ".")
        zeroButton = setButtonWith(title: "0")
        deleteButton = setButtonWith(title: "")
        deleteButton.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        deleteButton.isEnabled = false
        
        firstButtonStack.addArrangedSubview(dotButton)
        firstButtonStack.addArrangedSubview(zeroButton)
        firstButtonStack.addArrangedSubview(deleteButton)
        
        buttonsArray.append(dotButton)
        buttonsArray.append(zeroButton)
        
        sevenButton = setButtonWith(title: "7")
        eightButton = setButtonWith(title: "8")
        nineButton = setButtonWith(title: "9")
        secondButtonStack.addArrangedSubview(sevenButton)
        secondButtonStack.addArrangedSubview(eightButton)
        secondButtonStack.addArrangedSubview(nineButton)
        
        buttonsArray.append(sevenButton)
        buttonsArray.append(eightButton)
        buttonsArray.append(nineButton)
        
        fourButton = setButtonWith(title: "4")
        fiveButton = setButtonWith(title: "5")
        sixButton = setButtonWith(title: "6")
        thirdButtonStack.addArrangedSubview(fourButton)
        thirdButtonStack.addArrangedSubview(fiveButton)
        thirdButtonStack.addArrangedSubview(sixButton)
        
        buttonsArray.append(fourButton)
        buttonsArray.append(fiveButton)
        buttonsArray.append(sixButton)
        
        oneButton = setButtonWith(title: "1")
        twoButton = setButtonWith(title: "2")
        threeButton = setButtonWith(title: "3")
        fourButtonStack.addArrangedSubview(oneButton)
        fourButtonStack.addArrangedSubview(twoButton)
        fourButtonStack.addArrangedSubview(threeButton)
        
        buttonsArray.append(oneButton)
        buttonsArray.append(twoButton)
        buttonsArray.append(threeButton)
        
        selectedSpendCategoryButton = UIButton(type: .system)
        selectedSpendCategoryButton.backgroundColor = .white
        selectedSpendCategoryButton.alpha = 0.77
        selectedSpendCategoryButton.layer.borderWidth = 2
        selectedSpendCategoryButton.layer.borderColor = UIColor.defaultsColor.cgColor
        selectedSpendCategoryButton.layer.cornerRadius = 10
        selectedSpendCategoryButton.tintColor = .defaultsColor
        selectedSpendCategoryButton.setTitle("Категория", for: .normal)
        bottomStack.addArrangedSubview(selectedSpendCategoryButton)
        
        enterButton = UIButton(type: .system)
        enterButton.backgroundColor = .defaultsColor
        enterButton.alpha = 0.77
        enterButton.layer.cornerRadius = 10
        enterButton.tintColor = .white
        enterButton.setTitle("Ввод", for: .normal)
        enterButton.titleLabel?.font = UIFont(name: "Marker Felt Thin", size: 20)
        bottomStack.addArrangedSubview(enterButton)
        
        selectedAccountTypeButton = UIButton(type: .system)
        selectedAccountTypeButton.backgroundColor = .clear
        selectedAccountTypeButton.setTitle("Выберите аккаунт", for: .normal)
        selectedAccountTypeButton.tintColor = .defaultsColor
        selectedAccountTypeButton.titleLabel?.font = UIFont(name: "Marker felt", size: 18)
        selectedAccountTypeButton.alpha = 0.77
        addSubview(selectedAccountTypeButton)
    }
    
    private func setButtonWith(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Impact", size: 40)
        button.tintColor = .defaultsColor
        button.backgroundColor = .white
        button.alpha = 0.77
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.defaultsColor.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        if title.isEmpty {
            button.layer.borderWidth = 0
        }
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = (screenWidth - 100) / 3
        let device = Device.current
        switch device {
            case .iPhone8, .iPhoneSE2, .iPhoneSE3, .simulator(.iPhoneSE3), .simulator(.iPad10):
                button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1/2, constant: 20))
                button.layer.cornerRadius = buttonWidth / 7
            default:
                button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1/1, constant: 0))
                button.layer.cornerRadius = buttonWidth / 5
        }
        button.layer.add(bounceAnimation, forKey: nil)
        return button
    }
    
    private func labelSettings() {
        addSubview(cashLabel)
        cashLabel.font = UIFont(name: "Hiragino Maru Gothic ProN W4", size: 31)
        cashLabel.textAlignment = .center
        cashLabel.textColor = .defaultsColor
        cashLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(mainStack.snp.top).offset(-20)
        }
    }
    
    private func segmentControlSettings() {
        let items = ["Расход", "Доход"]
        controllerTypeSegmentControl = UISegmentedControl(items: items)
        controllerTypeSegmentControl.selectedSegmentIndex = 0
        controllerTypeSegmentControl.selectedSegmentTintColor = .defaultsColor
        if controllerTypeSegmentControl.selectedSegmentTintColor == .black {
            controllerTypeSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        }
        controllerTypeSegmentControl.alpha = 0.77
        addSubview(controllerTypeSegmentControl)
        let segmentInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        controllerTypeSegmentControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(segmentInsets)
            make.top.equalTo(safeAreaLayoutGuide)
        }
        selectedAccountTypeButton.snp.makeConstraints { make in
            make.top.equalTo(controllerTypeSegmentControl.snp.bottom).offset(10)
            make.leading.equalTo(100)
            make.trailing.equalTo(-100)
            make.height.equalTo(30)
        }
    }
    
    func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
    }
    
    // MARK: -
    // MARK: - Animations
    
    func labelAnimate(subTupe: CATransitionSubtype) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = subTupe
        animation.duration = 0.3
        cashLabel.layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func shakeAnimation(button: UIButton?) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.8
        animation.values = [0, -8.0, 8.0, -8.0, 8.0, -8.0, 8.0, 0]
        button?.layer.add(animation, forKey: nil)
    }
    
    func emptyFieldError() {
        errorLabel.text = "Введите сумму!"
        errorLabel.alpha = 0
        errorLabel.font = UIFont(name: "Marker Felt", size: 20)
        errorLabel.textColor = .red
        
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedAccountTypeButton.snp.bottom).offset(5)
            make.bottom.equalTo(mainStack.snp.top).offset(-5)
            make.centerX.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            self.errorLabel.alpha = 0.77
        } completion: { isFinish in
            guard isFinish else { return }
            UIView.animate(withDuration: 0.3) {
                self.errorLabel.alpha = 0
            } completion: { isFinish in
                guard isFinish else { return }
                UIView.animate(withDuration: 0.3) {
                    self.errorLabel.alpha = 0.77
                } completion: { isFinish in
                    guard isFinish else { return }
                    UIView.animate(withDuration: 0.3) {
                        self.errorLabel.alpha = 0
                    } completion: { isFinish in
                        guard isFinish else { return }
                        self.errorLabel.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func removeErrorLabel() {
        errorLabel.removeFromSuperview()
    }
    
    func accountError() {
        shakeAnimation(button: selectedAccountTypeButton)
        UIView.animate(withDuration: 0.3) {
            self.selectedAccountTypeButton.tintColor = .red
        } completion: { isFinish in
            guard isFinish else { return }
            UIView.animate(withDuration: 0.5) {
                self.selectedAccountTypeButton.tintColor = .defaultsColor
            }
        }
    }
    
    func categoryError() {
        shakeAnimation(button: selectedSpendCategoryButton)
        UIView.animate(withDuration: 0.3) {
            self.selectedSpendCategoryButton.layer.borderColor = UIColor.systemRed.cgColor
            self.selectedSpendCategoryButton.layer.borderWidth = 2
            self.selectedSpendCategoryButton.tintColor = .red
        } completion: { isFinish in
            guard isFinish else { return }
            UIView.animate(withDuration: 0.5) {
                self.selectedSpendCategoryButton.layer.borderColor = UIColor.defaultsColor.cgColor
                self.selectedSpendCategoryButton.layer.borderWidth = 2
                self.selectedSpendCategoryButton.tintColor = .defaultsColor
            }
        }
    }

}
