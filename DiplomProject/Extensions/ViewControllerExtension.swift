//
//  ViewControllerExtension.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import UIKit

extension UIViewController {
    func navigationSettings(title: String) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .defaultsColor
        navigationItem.title = title
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.defaultsColor, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 35) as Any]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.defaultsColor, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 20) as Any]
    }
    
    func showAlert(title: String, message: String, action: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel)
        let okBtn = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            action?()
        }
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
    }
}

extension UITextField {
    func addLeftAndRightView() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.rightViewMode = .always
    }
}

extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}

extension UIColor {
    static var defaultsColor = TintColorEnum.allCases[DefaultsManager.selectedColorIndex].color
    
    static func updateDefaultColor() {
        defaultsColor = TintColorEnum.allCases[DefaultsManager.selectedColorIndex].color
    }
    
}
