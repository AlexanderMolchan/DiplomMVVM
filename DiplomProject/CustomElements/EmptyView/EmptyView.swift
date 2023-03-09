//
//  EmptyView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 2.03.23.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    
    private let imageView = UIImageView()
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    
    var emptyViewColor = UIColor.defaultsColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateUI() {
        addSubview(imageView)
        imageView.image = UIImage(systemName: "xmark.icloud")
        imageView.tintColor = emptyViewColor
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        addSubview(topLabel)
        topLabel.font = UIFont(name: "Marker Felt Thin", size: 22)
        topLabel.textColor = emptyViewColor
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        topLabel.text = "У вас нет аккаунтов"
        topLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(imageView.snp.top).inset(-20)
        }
        
        addSubview(bottomLabel)
        bottomLabel.font = UIFont(name: "Marker Felt Thin", size: 22)
        bottomLabel.textColor = emptyViewColor
        bottomLabel.textAlignment = .center
        bottomLabel.numberOfLines = 0
        bottomLabel.text = "Перейдите в настройки, чтобы создать новые аккаунты и категории"
        bottomLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(imageView.snp.bottom).offset(25)
        }
    }
    
    func setLabelsText(top: String, bottom: String) {
        topLabel.text = top
        bottomLabel.text = bottom
    }
    
    func updateColors() {
        imageView.tintColor = .defaultsColor
        topLabel.textColor = .defaultsColor
        bottomLabel.textColor = .defaultsColor
    }
    
}
