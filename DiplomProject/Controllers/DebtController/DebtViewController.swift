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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    override func changeLanguage() {
        navigationSettings(title: Localization.Debts.navTitle.rawValue.localized())
        createDebtMenu()
    }
    
    override func observerAction() {
        updateNavigationColors()
        contentView.updateColor()
    }
    
    private func controllerConfiguration() {
        configurateUI()
        updateData()
        tableViewSettings()
    }
    
    private func updateData() {
        viewModel.getData()
        contentView.tableView.reloadData()
        emptyViewSettings()
    }
    
    private func configurateUI() {
        view.backgroundColor = defaultsBackgroundColor
        navigationSettings(title: Localization.Debts.navTitle.rawValue.localized())
        createDebtMenu()
    }
    
    private func tableViewSettings() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(DebtCell.self, forCellReuseIdentifier: DebtCell.id)
    }
    
    private func emptyViewSettings() {
        if viewModel.debtArray.isEmpty {
            contentView.addEmptyView()
        } else {
            contentView.removeEmptyView()
        }
    }
    
    private func createDebtMenu() {
        let addNewAccount = UIAction(
            title: Localization.Debts.menuTitle.rawValue.localized(),
            image: UIImage(systemName: "plus.app")
        ) { [weak self] _ in
            self?.createDebt()
        }
        let topMenu = UIMenu(children: [addNewAccount])
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), menu: topMenu)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func createDebt() {
        let reminderViewModel = DebtReminderViewModel(realm: viewModel.realm)
        let reminderVc = DebtReminderViewController(viewModel: reminderViewModel)
        reminderVc.dismissClosure = { [weak self] in
            self?.updateData()
        }
        navigationController?.present(reminderVc, animated: true)
    }
    
}

extension DebtViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.debtArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return DebtCell(debt: viewModel.debtArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contentView.tableView.performBatchUpdates {
                self.viewModel.deleteElementFromRealmAt(indexPath: indexPath)
                self.contentView.tableView.deleteRows(at: [indexPath], with: .left)
            }
            emptyViewSettings()
        }
    }
    
}
