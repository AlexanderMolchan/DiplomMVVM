//
//  AnalitycsCell.swift
//  DiplomProject
//
//  Created by Александр Молчан on 15.03.23.
//

import UIKit
import SnapKit

final class AnalitycsCell: UITableViewCell {
    static let id = String(describing: AnalitycsCell.self)
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 25)
        label.textColor = .defaultsColor
        return label
    }()
    
    private lazy var totalSpendLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 17)
        label.text = "Всего расходов:"
        return label
    }()
    
    private lazy var totalIncomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 17)
        label.text = "Всего доходов:"
        return label
    }()
    
    private lazy var spendSummLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 19)
        return label
    }()
    
    private lazy var incomeSummLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 19)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurate() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(totalSpendLabel)
        containerView.addSubview(totalIncomeLabel)
        containerView.addSubview(spendSummLabel)
        containerView.addSubview(incomeSummLabel)
        containerView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        selectionStyle = .none
    }
    
    private func makeConstraints() {
        let labelInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(labelInsets)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(labelInsets)
        }
        
        totalIncomeLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).inset(labelInsets)
            make.leading.equalToSuperview().inset(labelInsets)
        }
        
        totalSpendLabel.snp.makeConstraints { make in
            make.top.equalTo(totalIncomeLabel.snp.bottom).inset(labelInsets)
            make.leading.bottom.equalToSuperview().inset(labelInsets)
        }
        
        incomeSummLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalIncomeLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(labelInsets)
        }
        
        spendSummLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalSpendLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(labelInsets)
        }
    }
    
    func set(group: [CashModel]) {
        var spendSumm = 0.0
        var incomeSumm = 0.0
        group.forEach { flow in
            switch flow.cashFlow {
                case .spending:
                    spendSumm += flow.summ
                case .incoming:
                    incomeSumm += flow.summ
                default: break
            }
        }
        dateLabel.text = group.first?.stringDate
        let formattedSpend = String.formatSumm(summ: spendSumm)
        let formattedIncome = String.formatSumm(summ: incomeSumm)
        incomeSummLabel.text = formattedIncome
        spendSummLabel.text = formattedSpend
    }
}
