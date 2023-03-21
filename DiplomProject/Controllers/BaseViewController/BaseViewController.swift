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
        addObserverForLanguageChange()
    }
    
    deinit {
        removeObserverForColorChange()
        removeObserverForLanguageChange()
    }

    private func addObserverForColorChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(observerAction), name: NSNotification.Name("colorChanged"), object: nil)
    }
    
    private func addObserverForLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name("languageChanged"), object: nil)
    }
    
    private func removeObserverForColorChange() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("colorChanged"), object: nil)
    }
    
    private func removeObserverForLanguageChange() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("languageChanged"), object: nil)
    }
    
    @objc func observerAction() {
        
    }
    
    @objc func changeLanguage() {
        
    }
    
}
