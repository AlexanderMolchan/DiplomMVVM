//
//  AnalyticsViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit

typealias AnalyticsCell = GenericCell<AnalyticsCardView>

class AnalyticsViewController: BaseViewController {
    private let viewModel: AnalyticsViewModel
    let transitionManager = TransitionManager()
    
    private var contentView: AnalyticsViewControllerView {
        self.view as! AnalyticsViewControllerView
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setupData()
        tableView.reloadData()
    }
    
    private func configurateUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func controllerConfigurate() {
        viewModel.setupData()
        configurateUI()
        navigationSettings(title: "Аналитика")
        tableViewSettings()
    }
    
    private func tableViewSettings() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AnalyticsCell.self, forCellReuseIdentifier: String(describing: AnalyticsCell.self))
    }
    
    private func showNavBar() {
        UIView.animate(withDuration: 0.25) {
            self.navigationController?.navigationBar.alpha = 1
        }
    }
    
    private func hideNavBar() {
        UIView.animate(withDuration: 0.25) {
            self.navigationController?.navigationBar.alpha = 0
        }
    }
    
}

extension AnalyticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnalyticsCell.self), for: indexPath)
        guard let cardCell = cell as? AnalyticsCell else { return cell }
        
        cardCell.mainView.viewSettings(account: viewModel.accountArray[indexPath.row], type: .card, totalSumm: viewModel.totalSumm)
        return cardCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAccount = viewModel.accountArray[indexPath.row]
        let presentedVc = AnalitycsDetailViewController(account: currentAccount, type: .full, totalSumm: viewModel.totalSumm)
        presentedVc.modalPresentationStyle = .overFullScreen
        presentedVc.modalPresentationCapturesStatusBarAppearance = true
        presentedVc.transitioningDelegate = transitionManager
        guard let cell = tableView.cellForRow(at: indexPath) as? AnalyticsCell else { return }
        transitionManager.takeCard(card: cell.mainView, viewModel: viewModel)
        tabBarController?.setTabBarHidden(true, animated: true)
        hideNavBar()
        presentedVc.tabbarOpenClousure = {
            self.tabBarController?.setTabBarHidden(false, animated: true)
            self.showNavBar()
        }
        present(presentedVc, animated: true)
        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }
    
    func selectedCellCardView() -> AnalyticsCardView? {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let cell = tableView.cellForRow(at: indexPath) as? AnalyticsCell else { return nil }
        let cardView = cell.mainView
        return cardView
    }
    
}
