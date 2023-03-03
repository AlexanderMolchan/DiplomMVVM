//
//  TabBarViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

class TabBarViewModel {
    let realm: RealmManager
    
    init(realm: RealmManager) {
        self.realm = realm
    }
    
    func setViewControllers() -> [UIViewController] {
        let addTransactionViewModel = AddTransactionViewModel(realm: realm)
        let walletViewModel = WalletViewModel(realm: realm)
        let settingsViewModel = SettingsViewModel(realm: realm)
        
        let addTransactionVc = UINavigationController(rootViewController: AddTransactionViewController(viewModel: addTransactionViewModel))
        let walletVc = UINavigationController(rootViewController: WalletViewController(viewModel: walletViewModel))
        let settingsVc = UINavigationController(rootViewController: SettingsViewController(viewModel: settingsViewModel))
        
        addTransactionVc.tabBarItem = UITabBarItem(title: "Добавить", image: UIImage(systemName: "plus.circle"), tag: 0)
        walletVc.tabBarItem = UITabBarItem(title: "Кошелек", image: UIImage(systemName: "creditcard.circle"), tag: 1)
        settingsVc.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape.2"), tag: 2)
        
        let controllers = [addTransactionVc, walletVc, settingsVc]
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
