//
//  NewHabitViewControlllerFactory.swift
//  Tracker
//
//  Created by Вадим Суханов on 28.06.2025.
//

import UIKit

final class NewHabitViewControlllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let trackerStore = TrackerStore()
        let trackerCategoryStore = TrackerCategoryStore()
        let viewModel = EditTrackerViewModel(trackerStore: trackerStore, categoryStore: trackerCategoryStore)
        let vc = EditTrackerViewController(viewModel: viewModel)
        return vc
    }
}

