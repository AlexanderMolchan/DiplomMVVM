//
//  SelectedAccountViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import UIKit
import SnapKit

class SelectedAccountViewController: UIViewController {
    private let viewModel: SelectedAccountViewModel
    
    private var tableView = UITableView()
    private let emptyView = EmptyView()
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
        emptyViewSettings()
    }
    
    private func emptyViewSettings() {
        emptyView.removeFromSuperview()
        switch viewModel.controllerType {
            case .account:
                if viewModel.accountArray.isEmpty {
                    createEmptyView(topTitle: "У вас нет активных счетов.", bottomTitle: "Перейдите в меню создания новых счетов, чтобы добавить их в список.", type: .account)
                }
            case .spendCategory:
                if viewModel.cashFlowCategoryArray.isEmpty {
                    createEmptyView(topTitle: "У вас нет категорий транзакций.", bottomTitle: "Перейдите в настройки, чтобы создать новые категории", type: .spendCategory)
                }
        }
    }
    
    private func createEmptyView(topTitle: String, bottomTitle: String, type: SelectedType) {
        emptyView.setLabelsText(top: topTitle, bottom: bottomTitle)
        view.addSubview(emptyView)
        switch type {
            case .account:
                emptyView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            case .spendCategory:
                if viewModel.controllerSubType == .choose {
                    emptyView.snp.makeConstraints { make in
                        make.leading.trailing.equalToSuperview()
                        make.top.equalToSuperview().inset(160)
                    }
                } else {
                    emptyView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                }
        }
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
            case .spendCategory:   return viewModel.cashFlowCategoryArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedCell.id, for: indexPath)
        guard let selectedAccountCell = cell as? SelectedCell else { return cell }
        switch viewModel.controllerType {
            case .account:
                selectedAccountCell.set(account: viewModel.accountArray[indexPath.row])
            case .spendCategory:
                selectedAccountCell.set(category: viewModel.cashFlowCategoryArray[indexPath.row].name)
        }
        return selectedAccountCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.controllerSubType {
            case .choose:
                switch viewModel.controllerType {
                    case .account:
                        let selectedAccount = viewModel.accountArray[indexPath.row]
                        nameChangeClosure?(selectedAccount)
                    case .spendCategory:
                        let selectedCategory = viewModel.cashFlowCategoryArray[indexPath.row]
                        categoryChangeClousure?(selectedCategory)
                }
                dismiss(animated: true)
            case .edit:
                tableView.deselectRow(at: indexPath, animated: true)
            default: break
        }

    }
    
}
 
