//
//  AnalitycsDetailViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 6.03.23.
//

import UIKit
import SnapKit

class AnalitycsDetailViewController: BaseViewController, UIScrollViewDelegate {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var snapShotView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
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
    
    lazy var testLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var viewsHidden: Bool = false {
        didSet {
            dismissButton.isHidden = viewsHidden
            cardView?.isHidden = viewsHidden
            testLabel.isHidden = viewsHidden
            tableView.isHidden = viewsHidden
            view.backgroundColor = viewsHidden ? .clear : .white
        }
    }
    
    private(set) var cardView: AnalyticsCardView?
    private var account: AccountModel
    private var type: CardViewMode
    private var totalSumm: Double
    var tabbarOpenClousure: (() -> Void)?
    
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
    
    private func configurate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectedCell.self, forCellReuseIdentifier: SelectedCell.id)
        configurateScrollView()
        configurateCardView()
        tableViewSettings()
        self.view.backgroundColor = .clear
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
        testLabel.text = "sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslk jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflklksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkdsjsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds sdlkfj lksjdf lksjd flksdjf slkd jfdslkjf kldsjf lksdj fklsdjf lkdsjf lkjsdlk fjsdlkf jsdlkj flksdjflksdjf lksdj flkjsdlk fjsldkjf lkdjflksjdlksjf lkdsj flkdsjf lkds "
        testLabel.alpha = 0
//        containerView.addSubview(testLabel)
//        testLabel.snp.makeConstraints { make in
//            make.top.equalTo(cardView.snp.bottom).offset(20)
//            make.left.right.equalTo(containerView).inset(20)
//            make.bottom.equalTo(containerView).offset(-20)
//        }
    }
    
    private func tableViewSettings() {
        guard let cardView else { return }
        
        tableView.alpha = 0
        
        containerView.addSubview(tableView)
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .systemGray5
        tableView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(20)
            make.left.right.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView).offset(-20)
            make.height.equalTo(300)
        }
    }
    
    func showElementsWithAnimate() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.testLabel.alpha = 1
            self.dismissButton.alpha = 1
            self.tableView.alpha = 1
        }
    }
    
    @objc private func closeViewController() {
        UIView.animate(withDuration: 0.2) {
            self.scrollView.setContentOffset(.zero, animated: false)
            self.testLabel.alpha = 0
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
        return account.allCashFlows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedCell.id, for: indexPath)
        guard let flowCell = cell as? SelectedCell else { return cell }
        flowCell.set(flow: account.allCashFlows[indexPath.row])
        
        return flowCell
    }
    
}
