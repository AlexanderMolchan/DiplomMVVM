//
//  TabBarViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

class TabBarViewModel {
    
    func setViewControllers() -> [UIViewController] {
        let addTransactionViewModel = AddTransactionViewModel()
        let walletViewModel = WalletViewModel()
        
        let addTransactionVc = UINavigationController(rootViewController: AddTransactionViewController(viewModel: addTransactionViewModel))
        let walletVc = UINavigationController(rootViewController: WalletControllerView(viewModel: walletViewModel))
        
        addTransactionVc.tabBarItem = UITabBarItem(title: "Добавить", image: UIImage(systemName: "plus.circle"), tag: 0)
        walletVc.tabBarItem = UITabBarItem(title: "Кошелек", image: UIImage(systemName: "creditcard.circle"), tag: 1)
        
        let controllers = [addTransactionVc, walletVc]
        return controllers
    }
    
    func hapticFeedBack() {
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
    }
    
    let bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.3, 0.9, 1.0]
        bounceAnimation.duration = 0.3
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

}
