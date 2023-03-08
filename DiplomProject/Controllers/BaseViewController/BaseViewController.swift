//
//  BaseViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 8.03.23.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    var defaultsBackgroundColor: UIColor = {
        return .white
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateController()
    }
    
    private func configurateController() {
        setupLayout()
        makeConstraints()
    }

    private func setupLayout() {

    }
    
    private func makeConstraints() {

    }
    
}
