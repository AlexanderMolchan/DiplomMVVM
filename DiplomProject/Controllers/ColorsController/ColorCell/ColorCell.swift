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
    
    private lazy var colorView: UIView = {
        let view = UIView()
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
        contentView.addSubview(colorView)
        let colorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(colorInsets)
            make.height.equalTo(40)
        }
        colorView.layer.cornerRadius = 6
        selectionStyle = .none
        
    }
    
    func set(color: UIColor){
        self.colorView.backgroundColor = color
    }
    
}
