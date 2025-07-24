//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Вадим Суханов on 12.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let onboardingService = OnboardingService()
        
        if onboardingService.isOnboardingCompleted() {
            let rootVC = TabBarController()
            window?.rootViewController = rootVC
        } else {
            let onboardingVC = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: nil,
                onboardingService: onboardingService
            )
            window?.rootViewController = onboardingVC
        }
        
        window?.makeKeyAndVisible()
    }

}

