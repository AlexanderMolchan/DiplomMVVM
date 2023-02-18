//
//  WalletViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit
import SnapKit

class WalletViewControllerView: UIView {
    
    let totalSummLabel = UILabel()
    let commentLabel = UILabel()
    var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        configurateLabels()
        configurateTableView()
    }
    
    private func configurateLabels() {
        addSubview(totalSummLabel)
        addSubview(commentLabel)
        
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
        commentLabel.text = "Общий баланс"
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(totalSummLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configurateTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func menuButtonConfigurate() {
        
    }
    
}
