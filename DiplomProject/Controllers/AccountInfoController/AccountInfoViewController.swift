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
    
}

extension AccountInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accountFlows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: SelectedCell.id, for: indexPath)
        guard let flowCell = cell as? SelectedCell else { return cell }
        flowCell.set(flow: viewModel.accountFlows[indexPath.row])
        return flowCell
    }
    
    
}
