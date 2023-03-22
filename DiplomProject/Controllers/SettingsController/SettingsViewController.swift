//
//  SettingsViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit

final class SettingsViewController: BaseViewController {
    private let viewModel: SettingsViewModel
    
    private var contentView: SettingsViewControllerView {
        self.view as! SettingsViewControllerView
    }
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = SettingsViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateVc()
        tableViewSettings()
    }
    
    override func observerAction() {
        contentView.tableView.reloadData()
    }
    
    override func changeLanguage() {
        contentView.tableView.reloadData()
        navigationSettings(title: Localization.Settings.title.rawValue.localized())
    }
    
    private func configurateVc() {
        view.backgroundColor = defaultsBackgroundColor
        navigationSettings(title: Localization.Settings.title.rawValue.localized())
        viewModel.configureCells()
        contentView.tableView.reloadData()
    }
    
    private func tableViewSettings() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.id)
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingPoints.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingPoints[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SettingCell(type: viewModel.settingPoints[indexPath.section][indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
        let type = viewModel.settingPoints[indexPath.section][indexPath.row]
        switch type {
            case .incomeTypes:
                pushToEditVc(flowType: .incoming)
            case .spendTypes:
                pushToEditVc(flowType: .spending)
            case .chooseColor:
                pushToColorsVc()
            case .chooseLanguage:
                languageChoose()
            case .currency:
                pushToCurrencyVc()
            case .deleteAllData:
                deleteAllAlert()
            default: break
        }
    }
    
    private func pushToEditVc(flowType: CashFlowType) {
        let editIncomeViewModel = SelectedAccountViewModel(controllerType: .spendCategory, controllerSubType: .edit, cashFlowType: flowType, realm: viewModel.realm)
        let editFlowVc = SelectedAccountViewController(viewModel: editIncomeViewModel)
        editFlowVc.title = flowType == .incoming ? Localization.Settings.incomeTypes.rawValue.localized() :
        Localization.Settings.spendTypes.rawValue.localized()
        navigationController?.pushViewController(editFlowVc, animated: true)
    }
    
    private func pushToColorsVc() {
        let colorsViewModel = ColorsViewModel()
        let colorsVc = ColorsViewController(viewModel: colorsViewModel)
        navigationController?.pushViewController(colorsVc, animated: true)
    }
    
    private func pushToCurrencyVc() {
        let currencyViewModel = CurrencyViewModel(provider: viewModel.provider)
        let currencyVc = CurrencyViewController(viewModel: currencyViewModel)
        
        navigationController?.pushViewController(currencyVc, animated: true)
    }
    
    private func languageChoose() {
        let alert = UIAlertController(
            title: Localization.Settings.languageTitle.rawValue.localized(),
            message: Localization.Settings.languageMessage.rawValue.localized(),
            preferredStyle: .actionSheet)
        LanguageType.allCases.forEach { language in
            let action = UIAlertAction(title: language.title, style: .default) { [weak self] _ in
                DefaultsManager.language = language.languageCode
                Bundle.setLanguage(lang: language.languageCode)
                self?.tabBarTitleReload()
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: Localization.Settings.alertCancel.rawValue.localized(), style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    private func tabBarTitleReload() {
        guard let items = tabBarController?.tabBar.items else { return }
        items.enumerated().forEach { index, item in
            item.title = Localization.TabBarTitle.allCases[index].rawValue.localized()
        }
    }
    
    private func deleteAllAlert() {
        let alert = UIAlertController(
            title: Localization.Settings.deleteAllTitle.rawValue.localized(),
            message: Localization.Settings.deleteAllMessage.rawValue.localized(),
            preferredStyle: .alert)
        let okBtn = UIAlertAction(title: Localization.Settings.alertConfirm.rawValue.localized(), style: .destructive) { [weak self] _ in
            self?.viewModel.deleteAllData()
        }
        let cancelBtn = UIAlertAction(title: Localization.Settings.alertCancel.rawValue.localized(), style: .cancel)
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
    }
    
}
