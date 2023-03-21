//
//  CurrencyCell.swift
//  DiplomProject
//
//  Created by Александр Молчан on 21.03.23.
//

import UIKit
import SnapKit

final class CurrencyCell: UITableViewCell {
    static let id = String(describing: CurrencyCell.self)
    
    private var currencyModel: CurrencyModel
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 22)
        return label
    }()
    
    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 25)
        label.textColor = .defaultsColor
        return label
    }()
    
    init(model: CurrencyModel) {
        self.currencyModel = model
        super.init(style: .default, reuseIdentifier: CurrencyCell.id)
        cellConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellConfiguration() {
        layoutElements()
        makeConstraints()
    }
    
    private func layoutElements() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(rateLabel)
        
        nameLabel.text = "\(currencyModel.name) (\(currencyModel.scale))"
        rateLabel.text = "\(currencyModel.rate)"
    }
    
    private func makeConstraints() {
        let labelInset = UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
        nameLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(labelInset)
        }
        rateLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(labelInset)
        }
    }
    
}
