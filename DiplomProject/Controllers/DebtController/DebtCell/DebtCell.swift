//
//  DebtCell.swift
//  DiplomProject
//
//  Created by Александр Молчан on 19.03.23.
//

import UIKit

final class DebtCell: UITableViewCell {
    static let id = String(describing: DebtCell.self)
    private(set) var debt: DebtModel
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 16)
        return label
    }()
    
    private lazy var returnLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(debt: DebtModel) {
        self.debt = debt
        super.init(style: .default, reuseIdentifier: DebtCell.id)
        configurateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateCell() {
        contentView.addSubview(mainLabel)
        contentView.addSubview(returnLabel)
        mainLabel.text = "\(debt.debterName) должен \(debt.summ)"
        returnLabel.text = debt.stringDate
        
        let labelInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        mainLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(labelInset)
        }
        returnLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).inset(-5)
            make.leading.trailing.bottom.equalToSuperview().inset(labelInset)
        }
    }
    
}
