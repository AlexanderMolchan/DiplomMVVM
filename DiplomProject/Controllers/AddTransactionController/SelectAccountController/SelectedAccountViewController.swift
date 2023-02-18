//
//  SelectedAccountViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import UIKit
import SnapKit

class SelectedAccountViewController: UIViewController {
    let viewModel: SelectedAccountViewModel
    
    var tableView = UITableView()
    var nameChangeClosure: ((AccountModel) -> ())?
    var categoryChangeClousure: ((CashFlowCategory) -> ())?
    
    init(viewModel: SelectedAccountViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSettings()
    }
    
    private func tableViewSettings() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .insetGrouped)
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectedCell.self, forCellReuseIdentifier: SelectedCell.id)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}

extension SelectedAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.controllerType {
            case .account:         return viewModel.accountArray.count
            case .spendCategory:   return viewModel.spendCategory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedCell.id, for: indexPath)
        guard let selectedAccountCell = cell as? SelectedCell else { return cell }
        switch viewModel.controllerType {
            case .account:
                selectedAccountCell.set(account: viewModel.accountArray[indexPath.row])
            case .spendCategory:
                selectedAccountCell.set(category: viewModel.spendCategory[indexPath.row].name)
        }
        return selectedAccountCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.controllerType {
            case .account:
                let selectedAccount = viewModel.accountArray[indexPath.row]
                nameChangeClosure?(selectedAccount)
            case .spendCategory:
                let selectedCategory = viewModel.spendCategory[indexPath.row]
                categoryChangeClousure?(selectedCategory)
        }
        dismiss(animated: true)
    }
    
}
 
