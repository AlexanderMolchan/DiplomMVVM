//
//  WalletViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

final class WalletViewController: BaseViewController {
    private let viewModel: WalletViewModel
    
    private var contentView: WalletViewControllerView {
        return self.view as! WalletViewControllerView
    }
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = WalletViewControllerView(type: viewModel.controllerType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfigurate()
        tableViewSettings()
        setupNavigationMenu()
        bindElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setupDataSource()
        emptyViewSettings()
    }
    
    override func observerAction() {
        updateColorsForObserver()
    }
    
    private func updateColorsForObserver() {
        contentView.contentColor = .defaultsColor
        contentView.updateColor()
        contentView.tableView.reloadData()
        updateNavigationColors()
    }
    
    private func bindElements() {
        viewModel.totalAccountSumm.bind { [weak self] summ in
            self?.contentView.totalSummLabel.text = summ
        }
    }
    
    private func controllerConfigurate() {
        view.backgroundColor = defaultsBackgroundColor
        switch viewModel.controllerType {
            case .wallet:
                navigationSettings(title: "Кошелек")
            case .account:
                navigationItem.largeTitleDisplayMode = .never
                self.title = viewModel.currentAccount?.name
                contentView.totalSummLabel.text = viewModel.currentAccount?.currentSummString
            default: break
        }
    }
    
    private func emptyViewSettings() {
        contentView.tableView.reloadData()
        switch viewModel.controllerType {
            case .wallet:   emptyView(isAdd: viewModel.accountArray.isEmpty)
            case .account:  emptyView(isAdd: viewModel.groupedAccountFlows.isEmpty)
            default: break
        }
    }
    
    private func emptyView(isAdd: Bool) {
        if isAdd {
            contentView.addEmptyView()
        } else {
            contentView.removeEmptyView()
        }
    }
    
    private func animatedEmptyViewShow() {
        contentView.emptyView.alpha = 0
        emptyViewSettings()
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.contentView.emptyView.alpha = 1
        }
    }
    
    private func tableViewSettings() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(SelectedCell.self, forCellReuseIdentifier: SelectedCell.id)
    }
    
    private func setupNavigationMenu() {
        switch viewModel.controllerType {
            case .wallet: walletMenu()
            case .account: accountMenu()
            default: break
        }
    }
    
    private func walletMenu() {
        let addNewAccount = UIAction(title: "Создать новый счет", image: UIImage(systemName: "plus.app")) { _ in
            self.pushTo(.create)
        }
        let sortByName = UIAction(title: "Сортировать по имени", image: UIImage(systemName: "textformat.alt")) { _ in }
        let sortBySumm = UIAction(title: "Сортировать по сумме", image: UIImage(systemName: "arrow.up.arrow.down")) { _ in }
        let subMenu = UIMenu(title: "Cортировка" ,options: .displayInline, children: [sortBySumm, sortByName])
        
        let topMenu = UIMenu(title: "Дополнительно", options: .displayInline, children: [addNewAccount, subMenu])
        
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), menu: topMenu)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func accountMenu() {
        let updateAccount = UIAction(title: "Редактировать счет", image: UIImage(systemName: "list.bullet.clipboard")) { [weak self] _ in
            self?.pushTo(.edit, popVc: true)
        }
        
        let deleteAccount = UIAction(title: "Удалить счет", image: UIImage(systemName: "delete.backward.fill"), attributes: .destructive) { [weak self] _ in
            self?.deleteAccount()
        }
        
        let deleteAllTransactions = UIAction(title: "Удалить транзакции", image: UIImage(systemName: "delete.backward"), attributes: .destructive) { [weak self] _ in
            self?.deleteTransactions()
        }
        
        let subMenu = UIMenu(options: .displayInline, children: [deleteAccount])

        let topMenu = UIMenu(title: "Дополнительно", options: .displayInline, children: [updateAccount, deleteAllTransactions, subMenu])
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), menu: topMenu)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func pushTo(_ type: ControllerType, popVc: Bool = false) {
        let viewModel = CreateEditViewModel(realm: viewModel.realm, currentAccount: viewModel.currentAccount, controllerType: type, objectType: .account)
        let createEditVc = CreateEditAccountViewController(viewModel: viewModel)
        createEditVc.dismissClosure = {
            self.viewModel.setupDataSource()
            self.emptyViewSettings()
            if popVc {
                self.navigationController?.popViewController(animated: false)
            }
        }
        present(createEditVc, animated: true)
    }
    
    private func deleteAccount() {
        showAlert(title: "Удалить текущий счет?", message: "Удалив текущий счет, вы удалите все транзакции, принадлежащие ему.") {
            self.viewModel.deleteCurrentAccount()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func deleteTransactions() {
        showAlert(title: "Удалить все транзакции?", message: "С данного счета будут удалены все транзакции.") {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else { return }
                self.contentView.tableView.alpha = 0
            } completion: { isFinish in
                guard isFinish else { return }
                self.viewModel.deleteAllTransactions()
                self.contentView.totalSummLabel.text = "\(self.viewModel.currentAccount?.currentSumm ?? 0.0)"
                self.animatedEmptyViewShow()
            }
        }
    }
    
    private func deleteFlows(indexPath: IndexPath) {
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
        contentView.totalSummLabel.text = viewModel.currentAccount?.currentSummString
    }

}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewModel.controllerType {
            case .account:
                return viewModel.groupedAccountFlows.count
            default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch viewModel.controllerType {
            case .account:
                guard let firstFlow = viewModel.groupedAccountFlows[section].first else { return "" }
                return firstFlow.stringDate
            default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.controllerType {
            case .wallet:       return viewModel.accountArray.count
            case .account:      return viewModel.groupedAccountFlows[section].count
            default:            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: SelectedCell.id, for: indexPath)
        guard let accountCell = cell as? SelectedCell else { return cell }
        switch viewModel.controllerType {
            case .wallet:
                accountCell.set(account: viewModel.accountArray[indexPath.row])
            case .account:
                accountCell.set(flow: viewModel.groupedAccountFlows[indexPath.section][indexPath.row])
            default: break
        }
        return accountCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.controllerType {
            case .wallet:
                let currentAccount = viewModel.accountArray[indexPath.row]
                let viewModel = WalletViewModel(realm: viewModel.realm, type: .account, currentAccount: currentAccount)
                let infoVc = WalletViewController(viewModel: viewModel)
                infoVc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(infoVc, animated: true)
            default: contentView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch viewModel.controllerType {
            case .account:
                return .delete
            default:
                return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch viewModel.controllerType {
            case .account:
                if editingStyle == .delete {
                    contentView.tableView.performBatchUpdates {
                        self.deleteFlows(indexPath: indexPath)
                    }
                }
            default: break
        }
    }
    
}
