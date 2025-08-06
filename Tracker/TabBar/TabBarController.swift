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
            title: NSLocalizedString("trackers", comment: "Трекеры"),
            image: UIImage(named: "tabbar_trackers"),
            selectedImage: nil
        )
        let trackersNavigationController = UINavigationController(
            rootViewController: trackersViewController
        )
        
        let statisticsViewController = StatisticsViewControllerFactory().make()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics", comment: "Статистика"),
            image: UIImage(named: "tabbar_statistic"),
            selectedImage: nil
        )
        let statisticsNavigationController = UINavigationController(
            rootViewController: statisticsViewController
        )
        viewControllers = [trackersNavigationController, statisticsNavigationController]
    }
    
    private func setupAppearance() {
        tabBar.frame.size.height = 50
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.ypTabBarBorder.cgColor
        borderLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: tabBar.frame.width,
            height: 1 / UIScreen.main.scale
        )
        
        tabBar.layer.addSublayer(borderLayer)
    }
}
