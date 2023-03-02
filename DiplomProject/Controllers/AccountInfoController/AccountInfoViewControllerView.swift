//
//  AccountInfoViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 18.02.23.
//

import UIKit
import SnapKit

class AccountInfoViewControllerView: UIView {
    
    var tableView = UITableView()
    let emptyView = EmptyView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        tableView = UITableView(frame: .zero, style: .plain)
        addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addEmptyView() {
        addSubview(emptyView)
        emptyView.setLabelsText(top: "На данном счете нет транзакций.", bottom: "Добавьте транзакции, чтобы они отображались здесь.")
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bringSubviewToFront(emptyView)
    }
    
    func removeEmptyView() {
        emptyView.removeFromSuperview()
    }
    
}
