//
//  WalletViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit
import SnapKit

final class WalletViewControllerView: UIView {
    private let controllerType: ControllerType
    private let commentLabel = UILabel()
    
    lazy var tableView = UITableView()
    lazy var emptyView = EmptyView()
    var contentColor: UIColor = .defaultsColor
    let totalSummLabel = UILabel()

    init(type: ControllerType) {
        self.controllerType = type
        super.init(frame: .zero)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        viewSettings()
        layoutElements()
    }
    
    private func viewSettings() {
        addSubview(tableView)
        addSubview(totalSummLabel)
        addSubview(commentLabel)
    }
    
    private func layoutElements() {
        switch controllerType {
            case .account:
                tableView = UITableView(frame: .zero, style: .plain)
            default:
                tableView = UITableView(frame: .zero, style: .insetGrouped)
        }
        setTitles()
        totalSummLabel.font = UIFont(name: "Hiragino Maru Gothic ProN W4", size: 32)
        totalSummLabel.textAlignment = .center
        totalSummLabel.textColor = contentColor
        totalSummLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        commentLabel.font = UIFont(name: "Marker Felt Thin", size: 17)
        commentLabel.textAlignment = .center
        commentLabel.textColor = contentColor
  
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(totalSummLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setTitles() {
        switch controllerType {
            case .account:
                commentLabel.text = Localization.Wallet.currentSumm.rawValue.localized()
            default:
                commentLabel.text = Localization.Wallet.totalSumm.rawValue.localized()
        }
    }
    
    func addEmptyView() {
        addSubview(emptyView)
        emptyView.emptyViewColor = contentColor
        emptyView.setLabelsText(top: controllerType.emptyViewTitle, bottom: controllerType.emptyViewMessage)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bringSubviewToFront(emptyView)
    }
    
    func removeEmptyView() {
        emptyView.removeFromSuperview()
    }
    
    func updateColor() {
        totalSummLabel.textColor = contentColor
        commentLabel.textColor = contentColor
        emptyView.updateColors()
    }
    
}
