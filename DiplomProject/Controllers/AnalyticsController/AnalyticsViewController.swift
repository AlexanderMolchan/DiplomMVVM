//
//  AnalyticsViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit

class AnalyticsViewController: UIViewController {
    private let viewModel: AnalyticsViewModel
    
    private var contentView: AnalyticsViewControllerView {
        self.view as! AnalyticsViewControllerView
    }
    
    init(viewModel: AnalyticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = AnalyticsViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfigurate()
    }
    
    private func controllerConfigurate() {
        navigationSettings(title: "Аналитика")
    }
}
