//
//  DebtViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit
import SnapKit

final class DebtViewControllerView: UIView {
    private let emptyView = EmptyView()
    
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
        emptyView.setLabelsText(top: "Раздел временно недоступен.", bottom: "Следите за обновлениями.")
        addSubview(emptyView)
    }
    
    private func makeConstraints() {
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateColors() {
        emptyView.updateColors()
    }
    
}
