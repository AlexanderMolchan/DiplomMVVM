//
//  ColorsViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 8.03.23.
//

import UIKit
import SnapKit

final class ColorsViewController: BaseViewController {
    private let viewModel: ColorsViewModel
    
    private var contentView: ColorsViewControllerView {
        self.view as! ColorsViewControllerView
    }
    
    init(viewModel: ColorsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = ColorsViewControllerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerConfigurate()
        collectionViewConfigurate()
    }
    
    private func controllerConfigurate() {
        view.backgroundColor = defaultsBackgroundColor
    }
    
    private func collectionViewConfigurate() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        contentView.collectionView.register(ColorCollectionCell.self, forCellWithReuseIdentifier: ColorCollectionCell.id)
        contentView.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func updateColors() {
        UIColor.updateDefaultColor()
        NotificationCenter.default.post(name: NSNotification.Name("colorChanged"), object: nil)
        updateNavigationColors()
        tabBarController?.tabBar.tintColor = .defaultsColor
    }
    
}

extension ColorsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionCell.id, for: indexPath)
        guard let colorCell = cell as? ColorCollectionCell else { return cell }
        colorCell.isSelected = viewModel.selectedIndex == indexPath
        colorCell.set(color: viewModel.colorsArray[indexPath.row].color)
        
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DefaultsManager.selectedColorIndex = indexPath.row
        viewModel.selectedIndex = indexPath
        updateColors()
        contentView.collectionView.reloadData()
    }
    
}

extension ColorsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 20 - 60) / 3
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
