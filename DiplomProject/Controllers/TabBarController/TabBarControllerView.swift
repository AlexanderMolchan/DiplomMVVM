//
//  TabBarControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

class TabBarControllerView: UITabBarController {

    let viewModel: TabBarViewModel
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        tabBarSettings()
        firstStartSettings()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item),
              tabBar.subviews.count > index + 1,
              let imageView = tabBar.subviews[index + 1].subviews.compactMap({ $0 as? UIImageView }).first else { return }
        imageView.layer.add(viewModel.bounceAnimation, forKey: nil)
        viewModel.hapticFeedBack()
    }
    
    private func setViewControllers() {
        viewControllers = viewModel.setViewControllers()
    }
    
    private func tabBarSettings() {
        tabBar.tintColor = .systemCyan
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = .white
        tabBar.alpha = 0.9
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func firstStartSettings() {
        if DefaultsManager.firstStart {
            let account = AccountModel(name: "Основной", creationgSumm: 2000, isCreditAccount: false)
            let secondAccount = AccountModel(name: "Дополнительный", creationgSumm: 1000, isCreditAccount: true)

            RealmManager<AccountModel>().write(object: account)
            RealmManager<AccountModel>().write(object: secondAccount)
            
            let firstSpendCategory = CashFlowCategory(name: "Продукты", isSpendingFlow: true)
            let secondSpendCategory = CashFlowCategory(name: "Платежи", isSpendingFlow: true)
            let thirdSpendCategory = CashFlowCategory(name: "Развлечения", isSpendingFlow: true)
            let fourSpendCategory = CashFlowCategory(name: "Автомобили", isSpendingFlow: true)

            let firstIncomingCategory = CashFlowCategory(name: "Зарплата", isSpendingFlow: false)
            let secondIncomingCategory = CashFlowCategory(name: "Чаевые", isSpendingFlow: false)
            let thirdIncomingCategory = CashFlowCategory(name: "Взятки", isSpendingFlow: false)
            let fourIncomingCategory = CashFlowCategory(name: "Пожертвования", isSpendingFlow: false)

            RealmManager<CashFlowCategory>().write(object: firstSpendCategory)
            RealmManager<CashFlowCategory>().write(object: secondSpendCategory)
            RealmManager<CashFlowCategory>().write(object: thirdSpendCategory)
            RealmManager<CashFlowCategory>().write(object: fourSpendCategory)

            RealmManager<CashFlowCategory>().write(object: firstIncomingCategory)
            RealmManager<CashFlowCategory>().write(object: secondIncomingCategory)
            RealmManager<CashFlowCategory>().write(object: thirdIncomingCategory)
            RealmManager<CashFlowCategory>().write(object: fourIncomingCategory)

            DefaultsManager.firstStart = false
        }
    }

}
