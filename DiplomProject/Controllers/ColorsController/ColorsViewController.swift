//
//  ColorsViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 8.03.23.
//

import UIKit
import SnapKit

class ColorsViewController: BaseViewController {
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
        tableViewConfigurate()
    }
    
    private func controllerConfigurate() {
        view.backgroundColor = defaultsBackgroundColor
    }
    
    private func tableViewConfigurate() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.register(ColorCell.self, forCellReuseIdentifier: ColorCell.id)
    }
    
}

extension ColorsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.colorsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: ColorCell.id, for: indexPath)
        guard let colorCell = cell as? ColorCell else { return cell }
        colorCell.isSelected = viewModel.selectedIndex == indexPath
        colorCell.set(color: viewModel.colorsArray[indexPath.row].color)
        return colorCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath
        DefaultsManager.selectedColorIndex = indexPath.row
        UIColor.updateDefaultColor()
        NotificationCenter.default.post(name: NSNotification.Name("colorChanged"), object: nil)

//        tabBarController?.tabBar.tintColor = .defaultsColor
        contentView.tableView.performBatchUpdates {
            contentView.tableView.reloadRows(at: [indexPath], with: .automatic)
            contentView.tableView.reloadData()
        }
    }
    

    
}
