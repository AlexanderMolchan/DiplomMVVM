//
//  CardView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 6.03.23.
//

import UIKit
import SnapKit
import Charts

enum CardViewMode {
    case card
    case full
}

final class AnalyticsCardView: UIView, ChartViewDelegate {
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.clipsToBounds = true
        return view
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var pieView: PieChartView = {
        let pieView = PieChartView()
        pieView.contentMode = .scaleAspectFit
        return pieView
    }()
    
    private lazy var bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 20)
        label.textColor = .black
        return label
    }()
    
    var type: CardViewMode?
    var currentAccount: AccountModel?
    var totalSumm: Double?
    
    init() {
        super.init(frame: .zero)
        configurate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurate() {
        layoutElements()
        makeConstraints()
    }
    
    func viewSettings(account: AccountModel, type: CardViewMode, totalSumm: Double) {
        self.currentAccount = account
        self.totalSumm = totalSumm
        self.type = type
        setupViews()
    }
    
    func updateLayout(for type: CardViewMode) {
        switch type {
            case .card:
                let containerInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
                containerView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(containerInsets)
                }
            case .full:
                containerView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
        }
    }
    
    private func layoutElements() {
        self.backgroundColor = .clear
        self.addSubview(shadowView)
        self.addSubview(containerView)
        containerView.addSubview(pieView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomLabel)
    }
    
    private func makeConstraints() {
        let containerInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(containerInsets)
        }
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let labelInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(labelInsets)
            make.top.equalToSuperview().inset(45)
        }
        
        pieView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        let bottomContainerInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(pieView.snp.bottom)
            make.height.equalTo(60)
            make.leading.trailing.bottom.equalToSuperview().inset(bottomContainerInsets)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(labelInsets)
        }
    }
    
    private func pieChartSettings() {
        pieView.delegate = self
        
        guard let totalSumm,
              let currentSumm = currentAccount?.currentSumm
        else { return }
        
        let partFromAll = (currentSumm * 100) / totalSumm
        let otherPart = 100.0 - partFromAll
        
        var entries = [ChartDataEntry]()
        let pieChartEntry = PieChartDataEntry(value: otherPart)
        let secondPieChartEntry = PieChartDataEntry(value: partFromAll)
        entries.append(pieChartEntry)
        entries.append(secondPieChartEntry)
        
        let dataSets = PieChartDataSet(entries: entries, label: "Category")
        let colors = [UIColor.lightGray, UIColor.defaultsColor]
        dataSets.colors = colors
        let data = PieChartData(dataSet: dataSets)
        pieView.data = data
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .heavy))
        data.setValueTextColor(.white)
        
        pieView.centerAttributedText = NSAttributedString(string: "\(Int(currentSumm))", attributes: [NSAttributedString.Key.foregroundColor: UIColor.defaultsColor, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 20) as Any])
        pieView.holeColor = .clear
        pieView.drawEntryLabelsEnabled = false
        pieView.rotationEnabled = false
    }
    
    private func setupViews() {
        switch type {
            case .card:
                let containerInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
                containerView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(containerInsets)
                }
                containerView.layer.cornerRadius = 20
            case .full:
                containerView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
            default: break
        }
        titleLabel.text = currentAccount?.name
        bottomLabel.text = currentAccount?.currentSummString
        pieChartSettings()
    }

}
