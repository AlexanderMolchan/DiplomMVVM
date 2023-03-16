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
    
    private lazy var lineChartView: LineChartView  = {
        let lineView = LineChartView()
        lineView.contentMode = .scaleAspectFit
        return lineView
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
        
        typeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(labelInsets)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel).inset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
//    private func pieChartSettings() {
//        pieView.delegate = self
//
//        guard let totalSumm,
//              let currentSumm = currentAccount?.currentSumm
//        else { return }
//
    //    guard let totalSumm,
    //              let currentSumm = currentAccount?.currentSumm
    //
//        let partFromAll = (currentSumm * 100) / totalSumm
//        let otherPart = 100.0 - partFromAll
//
//        var entries = [ChartDataEntry]()
//        let pieChartEntry = PieChartDataEntry(value: otherPart)
//        let secondPieChartEntry = PieChartDataEntry(value: partFromAll)
//        entries.append(pieChartEntry)
//        entries.append(secondPieChartEntry)
//
//        let dataSets = PieChartDataSet(entries: entries, label: "Category")
//        let colors = [UIColor.lightGray, UIColor.defaultsColor]
//        dataSets.colors = colors
//        let data = PieChartData(dataSet: dataSets)
//        pieView.data = data
//        let pFormatter = NumberFormatter()
//        pFormatter.numberStyle = .percent
//        pFormatter.maximumFractionDigits = 1
//        pFormatter.multiplier = 1
//        pFormatter.percentSymbol = " %"
//        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
//        data.setValueFont(.systemFont(ofSize: 11, weight: .heavy))
//        data.setValueTextColor(.white)
//
//        pieView.centerAttributedText = NSAttributedString(string: "\(Int(currentSumm))", attributes: [NSAttributedString.Key.foregroundColor: UIColor.defaultsColor, NSAttributedString.Key.font: UIFont(name: "Marker Felt", size: 20) as Any])
//        pieView.holeColor = .clear
//        pieView.drawEntryLabelsEnabled = false
//        pieView.rotationEnabled = false
//    }
    
    private func lineChartSettings() {
        lineChartView.delegate = self
        lineChartView.setScaleEnabled(false)
        lineChartView.legend.form = .circle
        lineChartView.legend.enabled = false

        let incomeEntryes = [ChartDataEntry(x: 1, y: 3), ChartDataEntry(x: 2, y: 4), ChartDataEntry(x: 3, y: 3), ChartDataEntry(x: 4, y: 7), ChartDataEntry(x: 5, y: 1), ChartDataEntry(x: 6, y: 10)]
        
        let spendEntryes = [ChartDataEntry(x: 1, y: 4), ChartDataEntry(x: 2, y: 1), ChartDataEntry(x: 3, y: 6), ChartDataEntry(x: 4, y: 2), ChartDataEntry(x: 5, y: 8), ChartDataEntry(x: 6, y: 1)]
        
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
        let dataSets = [incomeDataSet, spendDataSet]
        let data = LineChartData(dataSets: dataSets)

        data.setDrawValues(false)
        lineChartView.data = data
        
        
        
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
        titleLabel.textColor = .defaultsColor
        typeLabel.text = currentAccount?.type.name
        lineChartSettings()
    }

}
