//
//  AnalyticsViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit

typealias StatisticsCell = GenericCell<AnalyticsCardView>

final class AnalyticsViewController: BaseViewController {
    private let viewModel: AnalyticsViewModel
    let transitionManager = TransitionManager()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controllerConfigurate()
        contentView.tableView.reloadData()
    }
    
    override func observerAction() {
        contentView.updateColor()
    }
    
    private func controllerConfigurate() {
        viewModel.setupData()
        configurateUI()
        emptyViewSettings()
        tableViewSettings()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configurateUI() {
        view.backgroundColor = defaultsBackgroundColor
    }
    
    private func tableViewSettings() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(StatisticsCell.self, forCellReuseIdentifier: String(describing: StatisticsCell.self))
    }
    
    private func emptyViewSettings() {
        if viewModel.accountArray.isEmpty {
            contentView.addEmptyView()
        } else {
            contentView.removeEmptyView()
        }
    }

}

extension AnalyticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatisticsCell.self), for: indexPath)
        guard let cardCell = cell as? StatisticsCell else { return cell }
        
        cardCell.mainView.viewSettings(account: viewModel.accountArray[indexPath.row], type: .card, totalSumm: viewModel.totalSumm)
        cardCell.mainView.animateChart()
        return cardCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAccount = viewModel.accountArray[indexPath.row]
        let detailViewModel = AnalyticsDetailViewModel(account: currentAccount, type: .full, totalSumm: viewModel.totalSumm, realm: viewModel.realm)
        
        let presentedVc = AnalyticsDetailViewController(viewModel: detailViewModel)
        presentedVc.modalPresentationStyle = .overFullScreen
        presentedVc.modalPresentationCapturesStatusBarAppearance = true
        presentedVc.transitioningDelegate = transitionManager
        guard let cell = tableView.cellForRow(at: indexPath) as? StatisticsCell else { return }
        transitionManager.takeCard(card: cell.mainView, viewModel: viewModel)
        tabBarController?.setTabBarHidden(true, animated: true)
        presentedVc.tabbarOpenClousure = {
            self.tabBarController?.setTabBarHidden(false, animated: true)
        }
        present(presentedVc, animated: true)
//        CFRunLoopWakeUp(CFRunLoopGetCurrent())
    }
    
    func selectedCellCardView() -> AnalyticsCardView? {
        guard let indexPath = contentView.tableView.indexPathForSelectedRow,
              let cell = contentView.tableView.cellForRow(at: indexPath) as? StatisticsCell else { return nil }
        let cardView = cell.mainView
        return cardView
    }
    
}
