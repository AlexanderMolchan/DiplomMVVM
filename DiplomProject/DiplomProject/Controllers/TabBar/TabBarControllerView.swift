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

}
