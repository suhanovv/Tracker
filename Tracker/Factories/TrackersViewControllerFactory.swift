//
//  TrackersViewControllerFactory.swift
//  Tracker
//
//  Created by Вадим Суханов on 10.07.2025.
//

import UIKit

final class TrackersViewControllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let trackerRecordStore = TrackerRecordStore()
        let trackerStore = TrackerStore()
        let categoryStore = TrackerCategoryStore()
        let dataProvider = TrackerDataProvider(store: trackerStore)
        let viewModel = TrackersViewModel(
            dataProvider: dataProvider,
            recordStore: trackerRecordStore,
            categoryStore: categoryStore
        )
        dataProvider.delegate = viewModel
        let viewController = TrackersViewController(viewModel: viewModel)
        return viewController
    }

    // MARK: - Helpers

    private func makeDefaultFilter(for date: Date) -> TrackerFilterRequest {
        TrackerFilterRequest(date: date)
    }
}
