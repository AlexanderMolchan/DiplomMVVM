//
//  DebtViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit

final class DebtViewController: BaseViewController {
    private let viewModel: DebtViewModel
    
    private var contentView: DebtViewControllerView {
        self.view as! DebtViewControllerView
    }
    
    init(viewModel: DebtViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = DebtViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfiguration()
    }
    
    override func observerAction() {
        updateNavigationColors()
        contentView.updateColors()
    }
    
    private func controllerConfiguration() {
        view.backgroundColor = defaultsBackgroundColor
        navigationSettings(title: "Долги")
    }
    
}
