//
//  AddTransactionViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import UIKit
import SnapKit

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
    
    let mainStack = UIStackView()
    let firstButtonStack = UIStackView()
    let secondButtonStack = UIStackView()
    let thirdButtonStack = UIStackView()
    let fourButtonStack = UIStackView()
    let bottomStack = UIStackView()
    let cashLabel = UILabel()
    
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
        selectedSpendCategoryButton.layer.borderColor = UIColor.systemCyan.cgColor
        selectedSpendCategoryButton.layer.cornerRadius = 10
        selectedSpendCategoryButton.tintColor = .systemCyan
        selectedSpendCategoryButton.setTitle("Тип расхода", for: .normal)
        bottomStack.addArrangedSubview(selectedSpendCategoryButton)
        
        enterButton = UIButton(type: .system)
        enterButton.backgroundColor = .systemCyan
        enterButton.alpha = 0.77
        enterButton.layer.cornerRadius = 10
        enterButton.tintColor = .white
        enterButton.setTitle("Ввод", for: .normal)
        enterButton.titleLabel?.font = UIFont(name: "Marker Felt Thin", size: 20)
        bottomStack.addArrangedSubview(enterButton)
    }
    
    private func setButtonWith(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Impact", size: 40)
        button.tintColor = .systemCyan
        button.backgroundColor = .white
        button.alpha = 0.77
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemCyan.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1/1, constant: 0))
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = (screenWidth - 100) / 3
        button.layer.cornerRadius = buttonWidth / 5
        if title.isEmpty {
            button.layer.borderWidth = 0
        }
        button.layer.add(bounceAnimation, forKey: nil)
        return button
    }
    
    private func labelSettings() {
        addSubview(cashLabel)
        cashLabel.font = UIFont(name: "Hiragino Maru Gothic ProN W4", size: 31)
        cashLabel.textAlignment = .center
        cashLabel.textColor = .systemCyan
        cashLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(mainStack.snp.top).offset(-20)
        }
    }
    
    func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
    }

}
