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
        label.font = UIFont(name: "Marker Felt", size: 25)
        label.textColor = .defaultsColor
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Marker Felt", size: 18)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var lineChartView: LineChartView = {
        let lineView = LineChartView()
        lineView.contentMode = .scaleAspectFit
        return lineView
    }()
    
    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var type: CardViewMode?
    var currentAccount: AccountModel?
    var totalSumm: Double?
    private var groupedAccountFlows = [[CashModel]]()
    
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
        transitionConstraintsRemake(type: type)
    }
    
    func animateChart() {
        lineChartView.animate(yAxisDuration: 0.4)
    }
    
    private func layoutElements() {
        self.backgroundColor = .clear
        self.addSubview(shadowView)
        self.addSubview(containerView)
        containerView.addSubview(lineChartView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(typeLabel)
    }
    
    private func emptyViewSettings() {
        if groupedAccountFlows.count < 2 {
            containerView.addSubview(emptyView)
            lineChartView.alpha = 0
            emptyView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(30)
            }
        } else {
            emptyView.removeFromSuperview()
            lineChartView.alpha = 1
        }
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
            make.top.equalToSuperview().inset(25)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(labelInsets)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(lineChartView.snp.top).inset(-20)
        }
        
        lineChartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func createDataGroups() {
        groupedAccountFlows.removeAll()
        guard let currentAccount else { return }
        let accountFlows = currentAccount.allCashFlows
        let groupedFlows = Dictionary.init(grouping: accountFlows) { element in
            return element.stringDate
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let sortedKeys = groupedFlows.keys.sorted { dateFormatter.date(from: $0) ?? Date.now < dateFormatter.date(from: $1) ?? Date.now }
        sortedKeys.forEach { key in
            guard let values = groupedFlows[key] else { return }
            groupedAccountFlows.append(values)
        }
    }
    
    private func lineChartSettings() {
        lineChartView.delegate = self
        lineChartView.setScaleEnabled(false)
        lineChartView.legend.enabled = false

        var incomeEntryes = [ChartDataEntry]()
        var spendEntryes = [ChartDataEntry]()
        var dateArray = [String]()
        groupedAccountFlows.enumerated().forEach { index, group in
            var incomeSumm = 0.0
            var spendSumm = 0.0
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM"
            dateArray.append(dateFormatter.string(from: group.first?.date ?? Date.now))
            group.forEach { cashModel in
                switch cashModel.cashFlow {
                    case .incoming: incomeSumm += cashModel.summ
                    case .spending: spendSumm += cashModel.summ
                    default: break
                }
            }
            let incomeEntry = ChartDataEntry(x: Double(index), y: incomeSumm)
            let spendEntry = ChartDataEntry(x: Double(index), y: spendSumm)
            incomeEntryes.append(incomeEntry)
            spendEntryes.append(spendEntry)
        }
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray)
        
        let incomeDataSet = LineChartDataSet(entries: incomeEntryes)
        incomeDataSet.drawCirclesEnabled = false
        incomeDataSet.lineWidth = 2
        incomeDataSet.mode = .cubicBezier
        incomeDataSet.fillAlpha = 0.4
        incomeDataSet.drawFilledEnabled = true
        incomeDataSet.fillColor = .green
        incomeDataSet.highlightColor = .black
        incomeDataSet.drawCircleHoleEnabled = false
        incomeDataSet.lineDashLengths = [5, 5]
        incomeDataSet.setColor(.defaultsColor)
        
        let spendDataSet = LineChartDataSet(entries: spendEntryes)
        spendDataSet.drawCirclesEnabled = false
        spendDataSet.lineWidth = 2
        spendDataSet.mode = .cubicBezier
        spendDataSet.fillAlpha = 0.2
        spendDataSet.drawFilledEnabled = true
        spendDataSet.fillColor = .red
        spendDataSet.highlightColor = .black
        spendDataSet.drawCircleHoleEnabled = false
        spendDataSet.lineDashLengths = [5, 5]
        spendDataSet.setColor(.defaultsColor)
        
        let dataSets = [incomeDataSet, spendDataSet]
        let data = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    private func transitionConstraintsRemake(type: CardViewMode?) {
        switch type {
            case .card:
                let containerInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
                containerView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(containerInsets)
                }
                titleLabel.snp.updateConstraints { make in
                    make.top.equalToSuperview().inset(25)
                }
                typeLabel.snp.updateConstraints { make in
                make.bottom.equalTo(lineChartView.snp.top).inset(-20)
                }
                containerView.layer.cornerRadius = 20
            case .full:
                containerView.snp.remakeConstraints { make in
                    make.edges.equalToSuperview()
                }
                titleLabel.snp.updateConstraints { make in
                    make.top.equalToSuperview().inset(55)
                    // device kit make enum with switch constraint
                }
                typeLabel.snp.updateConstraints { make in
                make.bottom.equalTo(lineChartView.snp.top)
                }
            default: break
        }
    }
    
    private func setupViews() {
        transitionConstraintsRemake(type: self.type)
        titleLabel.text = currentAccount?.name
        typeLabel.text = currentAccount?.type.name
        titleLabel.textColor = .defaultsColor
        emptyView.updateColors()
        createDataGroups()
        emptyViewSettings()
        lineChartSettings()
        emptyView.setForCardView(
            top: Localization.EmptyTitle.cardTop.rawValue.localized(),
            bottom: Localization.EmptyTitle.cardBot.rawValue.localized()
        )
    }

}
