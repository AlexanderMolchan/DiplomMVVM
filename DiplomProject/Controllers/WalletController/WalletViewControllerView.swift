//
//  WalletViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit
import SnapKit

class WalletViewControllerView: UIView {
    private let controllerType: ControllerType
    private let commentLabel = UILabel()
    
    let totalSummLabel = UILabel()
    var tableView = UITableView()
    let emptyView = EmptyView()

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
        backgroundColor = .white
        addSubview(tableView)
        addSubview(totalSummLabel)
        addSubview(commentLabel)
    }
    
    private func layoutElements() {
        switch controllerType {
            case .account:
                tableView = UITableView(frame: .zero, style: .plain)
                commentLabel.text = "Сумма на текущем аккаунте"
            default:
                tableView = UITableView(frame: .zero, style: .insetGrouped)
                commentLabel.text = "Общий баланс"
        }
        
        totalSummLabel.font = UIFont(name: "Hiragino Maru Gothic ProN W4", size: 32)
        totalSummLabel.textAlignment = .center
        totalSummLabel.textColor = .systemCyan
        totalSummLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        commentLabel.font = UIFont(name: "Marker Felt Thin", size: 17)
        commentLabel.textAlignment = .center
        commentLabel.textColor = .systemCyan
  
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
    
    func addEmptyView() {
        addSubview(emptyView)
        emptyView.setLabelsText(top: controllerType.emptyViewTitle, bottom: controllerType.emptyViewMessage)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bringSubviewToFront(emptyView)
    }
    
    func removeEmptyView() {
        emptyView.removeFromSuperview()
    }
    
}
