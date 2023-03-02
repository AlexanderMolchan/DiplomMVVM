//
//  SelectedCell.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.02.23.
//

import UIKit
import SnapKit

class SelectedCell: UITableViewCell {
    static let id = String(describing: SelectedCell.self)
    
    let cellImage = UIImageView()
    let cellLabel = UILabel()
    let summLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutElements() {
        backgroundColor = .lightGray.withAlphaComponent(0.15)
        
        addSubview(cellImage)
        cellImage.tintColor = .orange
        cellImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.width.equalTo(40)
        }
        cellImage.image = UIImage(systemName: "gear")
        
        addSubview(cellLabel)
        addSubview(summLabel)

        cellLabel.textColor = .systemCyan
        cellLabel.font = UIFont(name: "Chalkboard SE Bold", size: 18)
        cellLabel.snp.makeConstraints { make in
            make.leading.equalTo(cellImage.snp.trailing).offset(5)
            make.centerY.equalTo(cellImage.snp.centerY)
            make.trailing.lessThanOrEqualTo(summLabel.snp.leading).inset(-5)
        }
        cellLabel.adjustsFontForContentSizeCategory = true
        cellLabel.text = "Test text account"
        
        summLabel.textColor = .systemCyan
        summLabel.textAlignment = .right
        summLabel.font = UIFont(name: "Hiragino Sans W7", size: 15)
        summLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalTo(cellImage.snp.centerY)
        }
        summLabel.text = "54000$"
    }
    
    func set(account: AccountModel) {
        switch account.type {
            case .cash:
                cellImage.image = UIImage(systemName: "dollarsign.circle")
            case .credit:
                cellImage.image = UIImage(systemName: "creditcard.circle")
            default: break
        }
        cellLabel.text = "\(account.name)"
        summLabel.text = "\(Int(account.currentSumm))"
        if account.currentSumm > 0 {
            summLabel.textColor = .systemGreen
        } else {
            summLabel.textColor = .systemRed
        }
    }
    
    func set(category: String) {
        cellImage.isHidden = true
        summLabel.isHidden = true
        cellLabel.text = category
        cellLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    func set(flow: CashModel) {
        switch flow.cashFlow {
            case .incoming:
                cellImage.image = UIImage(systemName: "plus.circle")
                cellImage.tintColor = .systemGreen
                summLabel.textColor = .systemGreen
            case .spending:
                cellImage.image = UIImage(systemName: "minus.circle")
                cellImage.tintColor = .red
                summLabel.textColor = .red
            default: break
        }
        cellLabel.text = flow.category?.name
        summLabel.text = "\(flow.summ)"
    }
    
}


