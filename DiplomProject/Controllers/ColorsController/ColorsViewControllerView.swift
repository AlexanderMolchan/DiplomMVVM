//
//  ColorsViewControllerView.swift
//  DiplomProject
//
//  Created by Александр Молчан on 8.03.23.
//

import UIKit
import SnapKit

final class ColorsViewControllerView: UIView {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateViews() {
        let collectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(collectionInsets)
        }
    }
    
}
