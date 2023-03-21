//
//  TabBarViewModel.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

final class TabBarViewModel {
    let realm: RealmManager
    let provider: ProviderManager
    var tabBarTintColor = UIColor()
    
    init(realm: RealmManager, provider: ProviderManager) {
        self.realm = realm
        self.provider = provider
    }
    
    func setViewControllers() -> [UIViewController] {
        let addTransactionViewModel = AddTransactionViewModel(realm: realm)
        let walletViewModel = WalletViewModel(realm: realm, type: .wallet)
        let analyticsViewModel = AnalyticsViewModel(realm: realm)
        let debtViewModel = DebtViewModel(realm: realm)
        let settingsViewModel = SettingsViewModel(realm: realm, provider: provider)
        
        let addTransactionVc = UINavigationController(rootViewController: AddTransactionViewController(viewModel: addTransactionViewModel))
        let walletVc = UINavigationController(rootViewController: WalletViewController(viewModel: walletViewModel))
        let analyticsVc = UINavigationController(rootViewController: AnalyticsViewController(viewModel: analyticsViewModel))
        let debtVc = UINavigationController(rootViewController: DebtViewController(viewModel: debtViewModel))
        let settingsVc = UINavigationController(rootViewController: SettingsViewController(viewModel: settingsViewModel))
        
        addTransactionVc.tabBarItem = UITabBarItem(title: "Добавить", image: UIImage(systemName: "plus.circle"), tag: 0)
        walletVc.tabBarItem = UITabBarItem(title: "Кошелек", image: UIImage(systemName: "creditcard.circle"), tag: 1)
        analyticsVc.tabBarItem = UITabBarItem(title: "Аналитика", image: UIImage(systemName: "chart.bar"), tag: 2)
        debtVc.tabBarItem = UITabBarItem(title: "Долги", image: UIImage(systemName: "creditcard.trianglebadge.exclamationmark"), tag: 3)
        settingsVc.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape.2"), tag: 4)
        
        let controllers = [addTransactionVc, walletVc, analyticsVc, debtVc, settingsVc]
        return controllers
    }
    
    func hapticFeedBack() {
        if DefaultsManager.isHapticEnabled {
            let generator = UIImpactFeedbackGenerator()
            generator.impactOccurred()
        }
    }
    
    let bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.3, 0.9, 1.0]
        bounceAnimation.duration = 0.3
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

}
