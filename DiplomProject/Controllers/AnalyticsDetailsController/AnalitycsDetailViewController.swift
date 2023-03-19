//
//  AnalitycsDetailViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 6.03.23.
//

import UIKit
import SnapKit

final class AnalitycsDetailViewController: BaseViewController, UIScrollViewDelegate {
    private let viewModel: AnalyticsDetailViewModel
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "clear"), for: .normal)
        button.tintColor = .defaultsColor.withAlphaComponent(0.6)
        button.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var totalIncomeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .green.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var totalSpendContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var averageIncomeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .green.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var averageSpendContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red.withAlphaComponent(0.2)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var totalIncomeTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Chalkboard SE", size: 25)
        label.text = "0.0"
        return label
    }()
    
    private lazy var totalIncomeCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kohinoor Telugu", size: 14)
        label.text = "Сумма всех доходов"
        return label
    }()
    
    private lazy var totalSpendTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Chalkboard SE", size: 25)
        label.text = "0.0"

        return label
    }()
    
    private lazy var totalSpendCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kohinoor Telugu", size: 14)
        label.text = "Сумма всех расходов"
        return label
    }()
    
    private lazy var averageIncomeTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Chalkboard SE", size: 23)
        label.text = "0.0"
        return label
    }()
    
    private lazy var averageIncomeCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kohinoor Telugu", size: 14)
        label.text = "Доход в день"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var averageSpendTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Chalkboard SE", size: 23)
        label.text = "0.0"

        return label
    }()
    
    private lazy var averageSpendCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Kohinoor Telugu", size: 14)
        label.text = "Расход в день"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var categoryCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 23)
        return label
    }()
    
    private(set) var cardView: AnalyticsCardView?
        
    var viewsHidden: Bool = false {
        didSet {
            dismissButton.isHidden = viewsHidden
            cardView?.isHidden = viewsHidden
            tableView.isHidden = viewsHidden
            view.backgroundColor = viewsHidden ? .clear : .white
        }
    }
    
    var tabbarOpenClousure: (() -> Void)?
    
    init(viewModel: AnalyticsDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        remakeTableViewHeight()
    }
    
    private func configurate() {
        configurateScrollView()
        configurateCardView()
        viewModel.createDataGroups()
        layoutAnalitycsSubviews()
        makeAnalitycsConstraints()
        analitycsSettings()
        stackSubviewsInsert()
        tableViewSettings()
    }
    
    private func configurateScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view)
        }
    }
    
    private func configurateCardView() {
        cardView = AnalyticsCardView()
        cardView?.viewSettings(account: viewModel.account, type: viewModel.type, totalSumm: viewModel.totalSumm)
        guard let cardView else { return }
        scrollView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalToSuperview()
            make.height.equalTo(420)
        }
        dismissButton.alpha = 0
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-20)
        }
        view.bringSubviewToFront(dismissButton)
    }
    
    private func stackSubviewsInsert() {
        var categoryArray = viewModel.realm.read(type: CashFlowCategory.self).filter({ $0.type == .spending })
        categoryArray = categoryArray.sorted { firstFlow, secondFlow in
            viewModel.account.spending.filter({ $0.category?.name == firstFlow.name }).count > viewModel.account.spending.filter({ $0.category?.name == secondFlow.name }).count
        }
        guard !categoryArray.isEmpty else { return }
        containerView.addSubview(stackView)
        stackView.alpha = 0
        let stackInsets = UIEdgeInsets(top: 10, left: 15, bottom: -20, right: 15)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(averageSpendContainer.snp.bottom).inset(stackInsets)
            make.leading.trailing.equalToSuperview().inset(stackInsets)
        }
        categoryArray.forEach { category in
            let flowsCount = viewModel.account.spending.filter({ $0.category?.name == category.name }).count
            let allCategoryFlowsCount = viewModel.account.spending.count
            let label = UILabel()
            label.font = UIFont(name: "Marker Felt Thin", size: 17)
            
            
            let categoryString = "\(category.name): "
            let categoryAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Chalkboard SE", size: 19) as Any, .foregroundColor: UIColor.black]
            let categoryAttributedString = NSMutableAttributedString(string: categoryString, attributes: categoryAttributes)
            let countOfTransactionsString = "\(flowsCount)"
            let attributedCount = NSMutableAttributedString(string: countOfTransactionsString, attributes: categoryAttributes)
            
            let commentString = "количество транзакций - "
            let commentAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Marker Felt", size: 15) as Any, .foregroundColor: UIColor.lightGray]
            let commentAttributedString = NSMutableAttributedString(string: commentString, attributes: commentAttributes)
            let attributedString = NSMutableAttributedString(attributedString: categoryAttributedString)
            attributedString.append(commentAttributedString)
            attributedString.append(attributedCount)
            

            label.attributedText = attributedString
            let progress = UIProgressView()
            if viewModel.account.spending.isEmpty {
                progress.setProgress(0.0, animated: true)
            } else {
                progress.setProgress(Float(flowsCount)/Float(allCategoryFlowsCount), animated: true)
            }
            progress.trackTintColor = .systemGray4
            progress.progressTintColor = .defaultsColor
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(progress)
        }
    }
    
    private func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AnalitycsCell.self, forCellReuseIdentifier: AnalitycsCell.id)
        tableView.alpha = 0
        containerView.addSubview(tableView)
        
        if containerView.subviews.contains(stackView) {
            tableView.snp.makeConstraints { make in
                make.top.equalTo(stackView.snp.bottom).offset(20)
                make.left.right.equalTo(containerView).inset(10)
                make.bottom.equalTo(containerView).offset(-20)
                make.height.equalTo(100)
            }
        } else {
            tableView.snp.makeConstraints { make in
                make.top.equalTo(averageSpendContainer.snp.bottom).offset(5)
                make.left.right.equalTo(containerView).inset(10)
                make.bottom.equalTo(containerView).offset(-20)
                make.height.equalTo(100)
            }
        }
    }
    
    private func layoutAnalitycsSubviews() {
        containerView.addSubview(totalIncomeContainer)
        containerView.addSubview(totalSpendContainer)
        containerView.addSubview(averageIncomeContainer)
        containerView.addSubview(averageSpendContainer)
        
        totalIncomeContainer.alpha = 0
        totalSpendContainer.alpha = 0
        averageIncomeContainer.alpha = 0
        averageSpendContainer.alpha = 0
        
        totalIncomeContainer.addSubview(totalIncomeTitle)
        totalIncomeContainer.addSubview(totalIncomeCommentLabel)
        totalSpendContainer.addSubview(totalSpendTitle)
        totalSpendContainer.addSubview(totalSpendCommentLabel)
        
        averageIncomeContainer.addSubview(averageIncomeTitle)
        averageIncomeContainer.addSubview(averageIncomeCommentLabel)
        averageSpendContainer.addSubview(averageSpendTitle)
        averageSpendContainer.addSubview(averageSpendCommentLabel)
    }
    
    private func makeAnalitycsConstraints() {
        guard let cardView else { return }
        let screen = UIScreen.main.bounds.width
        let containerWidth = (screen - 40) / 2
        let containerInsets = UIEdgeInsets(top: 10, left: 15, bottom: -10, right: 15)
        let labelInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        totalIncomeContainer.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).inset(containerInsets)
            make.leading.equalToSuperview().inset(containerInsets)
            make.width.equalTo(containerWidth)
        }
        
        totalIncomeTitle.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(labelInsets)
        }
        
        totalIncomeCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(totalIncomeTitle.snp.bottom).inset(labelInsets)
            make.leading.trailing.bottom.equalToSuperview().inset(labelInsets)
        }
        
        totalSpendContainer.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).inset(containerInsets)
            make.trailing.equalToSuperview().inset(containerInsets)
            make.width.equalTo(containerWidth)
        }
        
        totalSpendTitle.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(labelInsets)
        }
        
        totalSpendCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(totalSpendTitle.snp.bottom).inset(labelInsets)
            make.leading.trailing.bottom.equalToSuperview().inset(labelInsets)
        }
        
        averageIncomeContainer.snp.makeConstraints { make in
            make.top.equalTo(totalIncomeContainer.snp.bottom).inset(containerInsets)
            make.leading.equalToSuperview().inset(containerInsets)
            make.width.equalTo(containerWidth)
        }
        
        averageIncomeTitle.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(labelInsets)
        }
        
        averageIncomeCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(averageIncomeTitle.snp.bottom).inset(labelInsets)
            make.leading.trailing.bottom.equalToSuperview().inset(labelInsets)
        }
        
        averageSpendContainer.snp.makeConstraints { make in
            make.top.equalTo(totalSpendContainer.snp.bottom).inset(containerInsets)
            make.trailing.equalToSuperview().inset(containerInsets)
            make.width.equalTo(containerWidth)
        }
        
        averageSpendTitle.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(labelInsets)
        }
        
        averageSpendCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(averageSpendTitle.snp.bottom).inset(labelInsets)
            make.leading.trailing.bottom.equalToSuperview().inset(labelInsets)
        }
    }

    private func analitycsSettings() {
        var totalIncome = 0.0
        var totalSpend = 0.0

        viewModel.account.allCashFlows.forEach { cashFlow in
            switch cashFlow.cashFlow {
                case .incoming:
                    totalIncome += cashFlow.summ
                case .spending:
                    totalSpend += cashFlow.summ
                default: break
            }
        }
        
        let totalIncomeSumm = String.formatSumm(summ: totalIncome)
        let totalSpendSumm = String.formatSumm(summ: totalSpend)
        totalIncomeTitle.text = totalIncomeSumm
        totalSpendTitle.text = totalSpendSumm
        
        if !viewModel.groupedAccountFlows.isEmpty {
            let averageIncome = String.formatSumm(summ: totalIncome / Double(viewModel.groupedAccountFlows.count))
            let averageSpend = String.formatSumm(summ: totalSpend / Double(viewModel.groupedAccountFlows.count))
            averageIncomeTitle.text = averageIncome
            averageSpendTitle.text = averageSpend
        } else {
            averageIncomeTitle.text = String.formatSumm(summ: 0.0)
            averageSpendTitle.text = String.formatSumm(summ: 0.0)
        }
    }
    
    private func remakeTableViewHeight() {
        let contentSize = tableView.contentSize.height
        tableView.snp.updateConstraints { make in
            make.height.equalTo(contentSize)
        }
    }
    
    func showElementsWithAnimate() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.dismissButton.alpha = 1
            self.tableView.alpha = 1
            self.totalIncomeContainer.alpha = 1
            self.totalSpendContainer.alpha = 1
            self.averageIncomeContainer.alpha = 1
            self.averageSpendContainer.alpha = 1
            self.stackView.alpha = 1
        }
    }
    
    @objc private func closeViewController() {
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(.zero, animated: false)
            self.tableView.alpha = 0
            self.dismissButton.alpha = 0
            self.totalIncomeContainer.alpha = 0
            self.totalSpendContainer.alpha = 0
            self.averageIncomeContainer.alpha = 0
            self.averageSpendContainer.alpha = 0
            self.stackView.alpha = 0
        } completion: { isFinish in
            guard isFinish else { return }
            self.dismiss(animated: true) {
                self.tabbarOpenClousure?()
            }
        }
    }
    
}

extension AnalitycsDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupedAccountFlows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnalitycsCell.id, for: indexPath)
        guard let totalCell = cell as? AnalitycsCell else { return cell }
        totalCell.set(group: viewModel.groupedAccountFlows[indexPath.row])

        return totalCell
    }
    
}
