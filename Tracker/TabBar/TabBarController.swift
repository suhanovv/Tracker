//
//  TabBarController.swift
//  Tracker
//
//  Created by Вадим Суханов on 12.06.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        configureViewControllers()

    }
    
    private func configureViewControllers() {
        let trackersViewController = TrackersViewControllerFactory().make()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tabbar_trackers"),
            selectedImage: nil
        )
        let trackersNavigationController = UINavigationController(
            rootViewController: trackersViewController
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tabbar_statistic"),
            selectedImage: nil
        )
        let statisticsNavigationController = UINavigationController(
            rootViewController: statisticsViewController
        )
        viewControllers = [trackersNavigationController, statisticsNavigationController]
    }
    
    private func setupAppearance() {
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.ypGrey.cgColor
        tabBar.frame.size.height = 50
        
        
    }
}
