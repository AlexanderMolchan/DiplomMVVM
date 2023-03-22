//
//  SceneDelegate.swift
//  DiplomProject
//
//  Created by Александр Молчан on 10.02.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var overlayWindow: UIWindow?
    private var scene: UIWindowScene?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.scene = scene
        window = UIWindow(windowScene: scene)
        window?.windowScene = scene
        let realm = RealmManager()
        let provider = ProviderManager()
        let tabBarViewModel = TabBarViewModel(realm: realm, provider: provider)
        window?.rootViewController = TabBarControllerView(viewModel: tabBarViewModel)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        removeOverlay()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        createBlurOverlay()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func createWindow() {
        guard let scene else { return }
        overlayWindow = UIWindow(windowScene: scene)
        overlayWindow?.windowLevel = .alert
        overlayWindow?.makeKeyAndVisible()
    }
    
    private func createBlurOverlay() {
        createWindow()
        let blurVc = UIViewController()
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurVc.view.bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurVc.view.addSubview(blurEffectView)
        overlayWindow?.rootViewController = blurVc
    }
    
    private func removeOverlay() {
        overlayWindow = nil
    }

}

