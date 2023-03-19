//
//  DebtViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit
import SnapKit

final class DebtViewControllerView: UIView {
    private lazy var emptyView = EmptyView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configurateUI() {
        layoutElements()
        makeConstraints()
    }
    
    private func layoutElements() {
        addSubview(tableView)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addEmptyView() {
        addSubview(emptyView)
        emptyView.emptyViewColor = .defaultsColor
        emptyView.setLabelsText(top: "У вас нет записей о долгах.", bottom: "Создайте новые записи, и они будут отображены здесь.")
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bringSubviewToFront(emptyView)
    }
    
    func removeEmptyView() {
        emptyView.removeFromSuperview()
    }
    
    func updateColor() {
        emptyView.updateColors()
    }
    
}
