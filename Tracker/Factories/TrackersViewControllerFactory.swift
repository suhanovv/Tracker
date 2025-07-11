//
//  TrackersViewControllerFactory.swift
//  Tracker
//
//  Created by Вадим Суханов on 10.07.2025.
//

import UIKit

final class TrackersViewControllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let defaultDate = Calendar.current.startOfDay(for: Date())
        let filter = makeDefaultFilter(for: defaultDate)
        let trackerRecordStore = TrackerRecordStore()

        guard let dataProvider = try? TrackerDataProvider(
            trackerRecordStore: trackerRecordStore,
            filter: filter
        ) else {
            assertionFailure("❌ Failed to create TrackerDataProvider")
            return UIViewController()
        }

        let viewController = TrackersViewController(
            trackerDataProvider: dataProvider,
            currentDate: defaultDate
        )
        dataProvider.delegate = viewController
        return viewController
    }

    // MARK: - Helpers

    private func makeDefaultFilter(for date: Date) -> TrackerFilter {
        let day = DayOfWeek.dayOfWeekFromDate(date)
        return TrackerFilter(dayOfWeek: day)
    }
}
