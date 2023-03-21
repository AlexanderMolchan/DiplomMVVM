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
        label.font = UIFont(name: "Marker Felt", size: 20)
        label.numberOfLines = 0
        label.textColor = .defaultsColor
        return label
    }()
    
    private lazy var returnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 14)
        return label
    }()
    
    private lazy var reminderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 14)
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
        returnLabel.text = "Дата возврата: \(debt.stringDate)"
        reminderLabel.text = "Дата напоминания: "
        
        let labelInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        mainLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(labelInset)
        }
        returnLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).inset(-5)
            make.leading.trailing.bottom.equalToSuperview().inset(labelInset)
        }
        
        guard let notificationDate = debt.notificationDate else { return }
        contentView.addSubview(reminderLabel)
        returnLabel.snp.remakeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).inset(-5)
            make.leading.trailing.equalToSuperview().inset(labelInset)
        }
        reminderLabel.snp.makeConstraints { make in
            make.top.equalTo(returnLabel.snp.bottom).inset(-5)
            make.leading.trailing.bottom.equalToSuperview().inset(labelInset)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        let stringNotificationDate = dateFormatter.string(from: notificationDate)
        reminderLabel.text? += stringNotificationDate
    }
    
}
