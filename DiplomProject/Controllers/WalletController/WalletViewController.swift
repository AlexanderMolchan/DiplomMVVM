//
//  WalletViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

class WalletViewController: UIViewController {
    let viewModel: WalletViewModel
    
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
        self.view = WalletViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfigurate()
        tableViewSettings()
        setupNavigationMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadAccountData()
        contentView.totalSummLabel.text = viewModel.totalAccountSumm.value
        contentView.tableView.reloadData()
    }
    
    private func controllerConfigurate() {
        view.backgroundColor = .white
        navigationSettings(title: "Кошелек")
        viewModel.reloadAccountData()
        contentView.totalSummLabel.text = viewModel.totalAccountSumm.value
    }
    
    private func tableViewSettings() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(SelectedCell.self, forCellReuseIdentifier: SelectedCell.id)
    }
    
    private func setupNavigationMenu() {
        let addNewAccount = UIAction(title: "Создать новый счет", image: UIImage(systemName: "plus.app")) { _ in
            self.createAccount()
        }
        let sortByName = UIAction(title: "Сортировать по имени", image: UIImage(systemName: "textformat.alt")) { _ in }
        let sortBySumm = UIAction(title: "Сортировать по сумме", image: UIImage(systemName: "arrow.up.arrow.down")) { _ in }
        let subMenu = UIMenu(title: "Cортировка" ,options: .displayInline, children: [sortBySumm, sortByName])
        
        let topMenu = UIMenu(title: "Дополнительно", options: .displayInline, children: [addNewAccount, subMenu])
        
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), menu: topMenu)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func createAccount() {
        let viewModel = CreateEditViewModel(realm: viewModel.realm, controllerType: .create)
        let createVc = CreateEditAccountViewController(viewModel: viewModel)
        createVc.dismissClosure = {
            self.viewModel.reloadAccountData()
            self.contentView.tableView.reloadData()
        }
        present(createVc, animated: true)
    }

}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: SelectedCell.id, for: indexPath)
        guard let accountCell = cell as? SelectedCell else { return cell }
        accountCell.set(account: viewModel.accountArray[indexPath.row])
        return accountCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentAccount = viewModel.accountArray[indexPath.row]
        let viewModel = AccountInfoViewModel(currentAccount: currentAccount, realm: viewModel.realm)
        let infoVc = AccountInfoViewController(viewModel: viewModel)
        infoVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(infoVc, animated: true)
    }
    
}
