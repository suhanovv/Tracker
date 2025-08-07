//
//  AppDelegate.swift
//  Tracker
//
//  Created by Вадим Суханов on 12.06.2025.
//

import UIKit
import AppMetricaCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let configuration = AppMetricaConfiguration(apiKey: AppMetricaConfig.apiKey) {
                AppMetrica.activate(with: configuration)
            }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

