//
//  ColorsViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 8.03.23.
//

import UIKit
import SnapKit

class ColorsViewControllerView: UIView {
    
    lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont(name: "Chalkboard SE", size: 16)
        label.text = "Выбранный цвет будет применен после перезапуска приложения."
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateViews() {
        addSubview(tableView)
        addSubview(warningLabel)
        let labelInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(labelInsets)
            make.leading.trailing.equalToSuperview().inset(labelInsets)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
