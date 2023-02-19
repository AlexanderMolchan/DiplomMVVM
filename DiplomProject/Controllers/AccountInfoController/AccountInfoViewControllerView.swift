//
//  AccountInfoViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit
import SnapKit

class AccountInfoViewControllerView: UIView {
    
    var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        tableView = UITableView(frame: .zero, style: .plain)
        addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
