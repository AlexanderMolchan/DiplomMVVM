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
        navigationController?.navigationBar.tintColor = .systemCyan
        navigationItem.title = title
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemCyan, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 35) as Any]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemCyan, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 20) as Any]
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
