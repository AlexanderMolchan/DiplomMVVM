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