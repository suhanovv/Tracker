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
        let viewModel = NewHabitViewModel(trackerStore: trackerStore, categoryStore: trackerCategoryStore)
        let vc = NewHabitViewController(viewModel: viewModel)
        return vc
    }
}

