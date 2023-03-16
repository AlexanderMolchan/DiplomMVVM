//
//  BaseViewController.swift
//  DiplomProject
//
//  Created by Александр Молчан on 8.03.23.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    var defaultsBackgroundColor: UIColor = {
        return .white
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverForColorChange()
    }
    
    deinit {
        removeObserverForColorChange()
    }

    func addObserverForColorChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(observerAction), name: NSNotification.Name("colorChanged"), object: nil)
    }
    
    func removeObserverForColorChange() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("colorChanged"), object: nil)
    }
    
    @objc func observerAction() {
        
    }
    
}
