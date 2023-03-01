//
//  AccountInfoViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit

class AccountInfoViewController: UIViewController {
    let viewModel: AccountInfoViewModel
    
    var contentView: AccountInfoViewControllerView {
        self.view as! AccountInfoViewControllerView
    }
    
    
    init(viewModel: AccountInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = AccountInfoViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupFlows()
        configurateVc()
        tableViewSettings()
        setupNavigationMenu()
    }
    
    private func configurateVc() {
        view.backgroundColor = .white
        self.title = viewModel.currentAccount.name
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func tableViewSettings() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(SelectedCell.self, forCellReuseIdentifier: SelectedCell.id)
    }
    
    private func setupNavigationMenu() {
        let updateAccount = UIAction(title: "Редактировать счет", image: UIImage(systemName: "list.bullet.clipboard")) { _ in
            self.updateAccount()
        }
        
        let deleteAccount = UIAction(title: "Удалить счет", image: UIImage(systemName: "delete.backward"), attributes: .destructive) { _ in
            self.deleteAccount()
        }

        let topMenu = UIMenu(title: "Дополнительно", options: .displayInline, children: [updateAccount, deleteAccount])
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), menu: topMenu)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func updateAccount() {
        let viewModel = CreateEditViewModel(controllerType: .edit)
        let updateVc = CreateEditAccountViewController(viewModel: viewModel)
        present(updateVc, animated: true)
    }
    
    private func deleteAccount() {
        
    }
    
}

extension AccountInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.groupedAccountFlows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let firstFlow = viewModel.groupedAccountFlows[section].first else { return "" }
        return firstFlow.stringDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.groupedAccountFlows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: SelectedCell.id, for: indexPath)
        guard let flowCell = cell as? SelectedCell else { return cell }
        flowCell.set(flow: viewModel.groupedAccountFlows[indexPath.section][indexPath.row])
        return flowCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contentView.tableView.performBatchUpdates {
                if viewModel.groupedAccountFlows[indexPath.section].count == 1 {
                    viewModel.deleteElementFromRealmAt(indexPath: indexPath)
                    let indexSet = IndexSet(arrayLiteral: indexPath.section)
                    contentView.tableView.cellForRow(at: indexPath)?.alpha = 0
                    contentView.tableView.deleteSections(indexSet, with: .automatic)
                } else {
                    viewModel.deleteElementFromRealmAt(indexPath: indexPath)
                    contentView.tableView.deleteRows(at: [indexPath], with: .left)
                }
            }
        }
    }
    
}
