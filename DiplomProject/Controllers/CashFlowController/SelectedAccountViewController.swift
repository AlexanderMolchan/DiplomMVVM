//
//  SelectedAccountViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import UIKit
import SnapKit

final class SelectedAccountViewController: BaseViewController {
    private let viewModel: SelectedAccountViewModel
    
    private var tableView = UITableView()
    private lazy var emptyView = EmptyView()
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
        setupCreateMenu()
    }
    
    private func emptyViewSettings() {
        emptyView.removeFromSuperview()
        tableView.reloadData()
        switch viewModel.controllerType {
            case .account:
                if viewModel.accountArray.isEmpty {
                    createEmptyView(
                        topTitle: Localization.Flows.emptyAccTop.rawValue.localized(),
                        bottomTitle: Localization.Flows.emptyAccBot.rawValue.localized(),
                        type: .account
                    )
                }
            case .spendCategory:
                if viewModel.cashFlowCategoryArray.isEmpty {
                    createEmptyView(
                        topTitle: Localization.Flows.emptyFlowTop.rawValue.localized(),
                        bottomTitle: Localization.Flows.emptyFlowBot.rawValue.localized(),
                        type: .spendCategory
                    )
                }
        }
    }
    
    private func createEmptyView(topTitle: String, bottomTitle: String, type: AccountOrCategoryType) {
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
        emptyView.alpha = 0
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            self.emptyView.alpha = 1
        }
    }
    
    private func tableViewSettings() {
        view.backgroundColor = defaultsBackgroundColor
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
    
    private func updateCategory(at index: IndexPath) {
        let viewModel = CreateEditViewModel(realm: viewModel.realm, currentCategory: viewModel.cashFlowCategoryArray[index.row], controllerType: .edit, objectType: .spendCategory, categoryType: viewModel.cashFlowType)
        pushToVcWith(model: viewModel)
    }
    
    private func deleteCategory(at indexPath: IndexPath) {
        let firstMessagePart = Localization.Flows.deleteMessageOne.rawValue.localized()
        let secondMessagePart = Localization.Flows.deleteMessageTwo.rawValue.localized()
        showAlert(
            title: Localization.Flows.deleteTitle.rawValue.localized(),
            message: (firstMessagePart + viewModel.cashFlowCategoryArray[indexPath.row].name + secondMessagePart)
        ) { [weak self] in
            self?.tableView.performBatchUpdates { [weak self] in
                self?.viewModel.deleteCategoryFromRealm(indexPath: indexPath)
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
                self?.emptyViewSettings()
            }
        }
    }
    
    @objc private func createCategory() {
        let viewModel = CreateEditViewModel(realm: viewModel.realm, controllerType: .create, objectType: .spendCategory, categoryType: viewModel.cashFlowType)
        pushToVcWith(model: viewModel)
    }
    
    private func setupCreateMenu() {
        switch viewModel.controllerSubType {
            case .edit:
                let createNewCategory = UIAction(title: Localization.Flows.createTitle.rawValue.localized(), image: UIImage(systemName: "plus.app")) { [weak self] _ in
                    self?.createCategory()
                }
                let topMenu = UIMenu(title: Localization.Flows.menuTitle.rawValue.localized(), options: .displayInline, children: [createNewCategory])
                let rightButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), menu: topMenu)
                navigationItem.rightBarButtonItem = rightButton
            default: break
        }
    }
    
    private func pushToVcWith(model: CreateEditViewModel) {
        let createEditVc = CreateEditAccountViewController(viewModel: model)
        createEditVc.dismissClosure = {
            self.viewModel.setupFlowData()
            self.emptyViewSettings()
        }
        createEditVc.modalPresentationStyle = .pageSheet
        guard let sheet = createEditVc.sheetPresentationController else { return }
        sheet.detents = [.medium()]
        present(createEditVc, animated: true)
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

extension SelectedAccountViewController {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if viewModel.controllerSubType == .edit {
            let identifier = "\(indexPath.row)" as NSString
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
                let updateAction = UIAction(title: Localization.Flows.edit.rawValue.localized(), image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
                    self?.updateCategory(at: indexPath)
                    
                }
                let deleteAction = UIAction(title: Localization.Flows.delete.rawValue.localized(), image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.deleteCategory(at: indexPath)
                }
                return UIMenu(children: [updateAction, deleteAction])
            }
        } else {
            return nil
        }
    }
    // beautifull pop vc
//    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
//        guard
//          let identifier = configuration.identifier as? String,
//          let index = Int(identifier)
//          else {
//            return
//        }
//        animator.addCompletion {
//            let vc = AddTransactionViewController(viewModel: AddTransactionViewModel(realm: self.viewModel.realm))
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }

}
 
