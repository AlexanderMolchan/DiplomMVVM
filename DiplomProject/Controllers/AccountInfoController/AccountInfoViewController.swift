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
        emptyViewSettings()
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
    
    private func emptyViewSettings() {
        contentView.tableView.reloadData()
        if viewModel.groupedAccountFlows.isEmpty {
            contentView.addEmptyView()
        } else {
            contentView.removeEmptyView()
        }
    }
    
    private func setupNavigationMenu() {
        let updateAccount = UIAction(title: "Редактировать счет", image: UIImage(systemName: "list.bullet.clipboard")) { _ in
            self.updateAccount()
        }
        
        let deleteAccount = UIAction(title: "Удалить счет", image: UIImage(systemName: "delete.backward.fill"), attributes: .destructive) { _ in
            self.deleteAccount()
        }
        
        let deleteAllTransactions = UIAction(title: "Удалить транзакции", image: UIImage(systemName: "delete.backward"), attributes: .destructive) { _ in
            self.deleteTransactions()
        }
        
        let subMenu = UIMenu(options: .displayInline, children: [deleteAccount])

        let topMenu = UIMenu(title: "Дополнительно", options: .displayInline, children: [updateAccount, deleteAllTransactions, subMenu])
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), menu: topMenu)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func updateAccount() {
        let viewModel = CreateEditViewModel(realm: viewModel.realm, currentAccount: viewModel.currentAccount, controllerType: .edit)
        let updateVc = CreateEditAccountViewController(viewModel: viewModel)
        updateVc.dismissClosure = {
            self.navigationController?.popViewController(animated: false)
        }
        present(updateVc, animated: true)
    }
    
    private func deleteAccount() {
        let alert = UIAlertController(title: "Удалить текущий счет?", message: "Удалив текущий счет, вы удалите все транзакции, принадлежащие ему.", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.viewModel.deleteCurrentAccount()
            self.navigationController?.popViewController(animated: true)
        }
        let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
    }
    
    private func deleteTransactions() {
        let alert = UIAlertController(title: "Удалить все транзакции?", message: "С данного счета будут удалены все транзакции.", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                self.contentView.tableView.alpha = 0
            } completion: { isFinish in
                guard isFinish else { return }
                self.viewModel.deleteAllTransactions()
                self.animatedEmptyViewShow()
            }
        }
        let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
    }
    
    private func animatedEmptyViewShow() {
        contentView.emptyView.alpha = 0
        emptyViewSettings()
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.contentView.emptyView.alpha = 1
        }
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
                    if viewModel.groupedAccountFlows.isEmpty {
                        animatedEmptyViewShow()
                    }
                } else {
                    viewModel.deleteElementFromRealmAt(indexPath: indexPath)
                    contentView.tableView.deleteRows(at: [indexPath], with: .left)
                }
            }
        }
    }
    
}
