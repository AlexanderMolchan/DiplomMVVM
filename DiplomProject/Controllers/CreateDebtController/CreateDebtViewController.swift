//
//  CreateDebtViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 19.03.23.
//

import UIKit
final class CreateDebtViewController: BaseViewController {
    private let viewModel: CreateDebtViewModel
    
    private var contentView: CreateDebtViewControllerView {
        self.view as! CreateDebtViewControllerView
    }
    
    init(viewModel: CreateDebtViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = CreateDebtViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
