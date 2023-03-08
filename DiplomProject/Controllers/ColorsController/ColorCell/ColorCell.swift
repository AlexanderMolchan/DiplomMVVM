//
//  ColorCell.swift
//  DiplomProject
//
//  Created by Александр Молчан on 8.03.23.
//

import UIKit
import SnapKit

class ColorCell: UITableViewCell {
    static let id = String(describing: ColorCell.self)
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 7
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateViews() {
        let colorInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        let containerInsets = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15)

        contentView.addSubview(containerView)
        containerView.addSubview(colorView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(containerInsets)
        }
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(colorInsets)
            make.height.equalTo(35)
        }
    }
    
    func set(color: UIColor){
        self.colorView.backgroundColor = color
        selectionStyle = .none
        if isSelected {
            containerView.backgroundColor = color.withAlphaComponent(0.3)
            self.colorView.layer.borderColor = UIColor.white.cgColor
            self.colorView.layer.borderWidth = 1
        } else {
            containerView.backgroundColor = .clear
            self.colorView.layer.borderWidth = 0
        }
    }
    
}
