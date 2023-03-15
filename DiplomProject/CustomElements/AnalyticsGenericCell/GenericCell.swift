//
//  GenericCell.swift
//  DiplomProject
//
//  Created by Александр Молчан on 6.03.23.
//

import UIKit
import SnapKit

final class GenericCell<T: UIView>: UITableViewCell {
    var mainView = T()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutMainView() {
        selectionStyle = .none
        self.backgroundColor = .clear
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

