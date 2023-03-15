//
//  ColorCollectionCell.swift
//  DiplomProject
//
//  Created by Александр Молчан on 14.03.23.
//

import UIKit
import SnapKit

final class ColorCollectionCell: UICollectionViewCell {
    static let id = String(describing: ColorCollectionCell.self)
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurate() {
        let containerInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(containerInsets)
        }
        
        let colorViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        containerView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(colorViewInsets)
        }
    }
    
    private func cellAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, 1.05, 0.95, 1.0]
        animation.duration = 0.3
        animation.calculationMode = .cubic
        self.colorView.layer.add(animation, forKey: nil)
        self.layer.add(animation, forKey: nil)
    }
    
    private func animateSelection(color: UIColor) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.containerView.backgroundColor = color.withAlphaComponent(0.3)
            self.colorView.layer.borderColor = UIColor.white.cgColor
            self.colorView.layer.borderWidth = 1
        }
    }
    
    func set(color: UIColor) {
        self.colorView.backgroundColor = color
        if isSelected {
            cellAnimation()
            animateSelection(color: color)
        } else {
            containerView.backgroundColor = .clear
            self.colorView.layer.borderWidth = 0
        }
    }
}

