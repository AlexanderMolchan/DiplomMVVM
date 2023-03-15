//
//  AnalitycsDetailViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 6.03.23.
//

import UIKit
import SnapKit

final class AnalitycsDetailViewController: BaseViewController, UIScrollViewDelegate {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "clear"), for: .normal)
        button.tintColor = .defaultsColor.withAlphaComponent(0.6)
        button.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        button.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private(set) var cardView: AnalyticsCardView?
    private var account: AccountModel
    private var type: CardViewMode
    private var totalSumm: Double
    private var groupedAccountFlows = [[CashModel]]()
    var tabbarOpenClousure: (() -> Void)?
    
    var viewsHidden: Bool = false {
        didSet {
            dismissButton.isHidden = viewsHidden
            cardView?.isHidden = viewsHidden
            tableView.isHidden = viewsHidden
            view.backgroundColor = viewsHidden ? .clear : .white
        }
    }
    
    init(account: AccountModel, type: CardViewMode, totalSumm: Double) {
        self.account = account
        self.type = type
        self.totalSumm = totalSumm
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
        createDataGroups()
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
        cardView?.viewSettings(account: account, type: type, totalSumm: totalSumm)
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
    
    private func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AnalitycsCell.self, forCellReuseIdentifier: AnalitycsCell.id)
        
        guard let cardView else { return }
        tableView.alpha = 0
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(20)
            make.left.right.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView).offset(-20)
            make.height.equalTo(100)
        }
    }
    
    private func createDataGroups() {
        let accountFlows = account.allCashFlows
        let groupedFlows = Dictionary.init(grouping: accountFlows) { element in
            return element.stringDate
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let sortedKeys = groupedFlows.keys.sorted { dateFormatter.date(from: $0) ?? Date.now > dateFormatter.date(from: $1) ?? Date.now }
        sortedKeys.forEach { key in
            guard let values = groupedFlows[key] else { return }
            groupedAccountFlows.append(values)
        }
        
    }
    
    private func remakeTableViewHeight() {
        let contentSize = tableView.contentSize.height
        tableView.snp.updateConstraints { make in
            make.height.equalTo(contentSize)
        }
    }
    
    func showElementsWithAnimate() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.dismissButton.alpha = 1
            self.tableView.alpha = 1
        }
    }
    
    @objc private func closeViewController() {
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(.zero, animated: false)
            self.tableView.alpha = 0
            self.dismissButton.alpha = 0
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
        return groupedAccountFlows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnalitycsCell.id, for: indexPath)
        guard let totalCell = cell as? AnalitycsCell else { return cell }
        totalCell.set(group: groupedAccountFlows[indexPath.row])

        return totalCell
    }
    
}
