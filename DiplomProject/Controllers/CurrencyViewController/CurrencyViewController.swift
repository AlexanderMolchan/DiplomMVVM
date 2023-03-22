//
//  CurrencyViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 21.03.23.
//

import UIKit
import SnapKit

final class CurrencyViewController: BaseViewController {
    private let viewModel: CurrencyViewModel
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .defaultsColor
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CurrencyCell.self,
            forCellReuseIdentifier: CurrencyCell.id
        )
        return tableView
    }()
    
    init(viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfiguration()
        getData()
    }
    
    private func controllerConfiguration() {
        layoutElements()
        makeConstraints()
    }
    
    private func layoutElements() {
        view.backgroundColor = .defaultsColor
        self.title = Localization.Settings.currency.rawValue.localized()
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.bringSubviewToFront(spinner)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func addEmptyView() {
        let emptyView = EmptyView()
        emptyView.setLabelsText(
            top: Localization.CurrencyTitles.emptyTop.rawValue.localized(),
            bottom: Localization.CurrencyTitles.emptyBot.rawValue.localized()
        )
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getData() {
        spinner.startAnimating()
        viewModel.provider.getCurrency { [weak self] result in
            self?.viewModel.currencyArray = result
            self?.viewModel.formatArray()
            self?.tableView.reloadData()
            if self?.viewModel.currencyArray.count == 0 {
                self?.addEmptyView()
            }
            self?.spinner.stopAnimating()
        } failure: { [weak self] _ in
            self?.addEmptyView()
            self?.spinner.stopAnimating()
        }
    }
    
}

extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CurrencyCell(model: viewModel.currencyArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
