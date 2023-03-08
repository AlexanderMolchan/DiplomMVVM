//
//  SettingsViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit

class SettingsViewController: BaseViewController {
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
    
    private func configurateVc() {
        view.backgroundColor = defaultsBackgroundColor
        navigationSettings(title: "Настройки")
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
            default: break
        }
    }
    
    private func pushToEditVc(flowType: CashFlowType) {
        let editIncomeViewModel = SelectedAccountViewModel(controllerType: .spendCategory, controllerSubType: .edit, cashFlowType: flowType, realm: viewModel.realm)
        let editFlowVc = SelectedAccountViewController(viewModel: editIncomeViewModel)
        editFlowVc.title = flowType.name
        navigationController?.pushViewController(editFlowVc, animated: true)
    }
    
    private func pushToColorsVc() {
        let colorsViewModel = ColorsViewModel()
        let colorsVc = ColorsViewController(viewModel: colorsViewModel)
        colorsVc.title = SettingsEnum.chooseColor.title
        navigationController?.pushViewController(colorsVc, animated: true)
    }
    
}
