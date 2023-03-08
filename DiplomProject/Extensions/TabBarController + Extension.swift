//
//  TabBarController + Extension.swift
//  DiplomProject
//
//  Created by Александр Молчан on 6.03.23.
//

import UIKit

extension UITabBarController {
    var tabBarHidden: Bool {
        tabBar.frame.origin.y >= UIScreen.main.bounds.height
    }
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        guard tabBarHidden != hidden else { return }
        
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = hidden ? height : -height

        UIViewPropertyAnimator(duration: animated ? 0.25 : 0, curve: .easeOut) {
            self.tabBar.frame = self.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        } .startAnimation()
    }
}

