//
//  TrackersViewControllerFactory.swift
//  Tracker
//
//  Created by Вадим Суханов on 10.07.2025.
//

import UIKit

final class StatisticsViewControllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let dataProvider = StatisticsDataProvider()
        let viewModel = StatisticsViewModel(dataProvider: dataProvider)
        dataProvider.delegate = viewModel
        let viewController = StatisticsViewController(viewModel: viewModel)
        
        return viewController
    }
}
