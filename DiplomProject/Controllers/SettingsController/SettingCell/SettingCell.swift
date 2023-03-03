//
//  SettingCell.swift
//  DiplomProject
//
//  Created by Александр Молчан on 3.03.23.
//

import UIKit
import SnapKit

class SettingCell: UITableViewCell {
    static let id = String(describing: SettingCell.self)
    private(set) var type: SettingsEnum
    
    private lazy var settingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemCyan
        return imageView
    }()
    
    private lazy var settingTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Chalkboard SE", size: 16)
        return label
    }()
    
    private lazy var statusSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = .systemCyan
        return switcher
    }()
    
    init(type: SettingsEnum) {
        self.type = type
        super.init(style: .default, reuseIdentifier: SettingCell.id)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        layoutElements()
        makeConstraints()
        setupData()
    }
    
    private func layoutElements() {
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        contentView.addSubview(settingImage)
        contentView.addSubview(settingTitle)
        contentView.addSubview(statusSwitch)
        selectionStyleFromType()
    }
    
    private func selectionStyleFromType() {
        switch type {
            case .summFormat, .vibrations:
                selectionStyle = .none
            default: selectionStyle = .default
        }
    }
    
    private func makeConstraints() {
        let elementInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        settingImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(elementInsets)
            make.height.width.equalTo(40)
        }
        
        settingTitle.snp.makeConstraints { make in
            make.leading.equalTo(settingImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        statusSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(elementInsets)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupData() {
        settingImage.image = type.image
        settingTitle.text = type.title
        statusSwitch.isHidden = !type.switchEnabled
        statusSwitch.isOn = true
        if type == .deleteAllData {
            settingImage.tintColor = .systemRed
            settingTitle.textColor = .systemRed
        }
    }
    
}
