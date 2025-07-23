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
        let dataProvider = TrackerDataProvider()
        let viewModel = TrackersViewModel(
            dataProvider: dataProvider,
            recordStore: trackerRecordStore
        )
        dataProvider.delegate = viewModel
        let viewController = TrackersViewController(viewModel: viewModel)
        return viewController
    }

    // MARK: - Helpers

    private func makeDefaultFilter(for date: Date) -> TrackerFilter {
        let day = DayOfWeek.dayOfWeekFromDate(date)
        return TrackerFilter(dayOfWeek: day)
    }
}
