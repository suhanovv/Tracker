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
        let defaultFilter = TrackerFilter(dayOfWeek: DayOfWeek.dayOfWeekFromDate(defaultDate))
        let trackerRecordStore = TrackerRecordStore()
        guard let dataProvider = try? TrackerDataProvider(
            trackerRecordStore: trackerRecordStore,
            filter: defaultFilter) else {
            fatalError("Data provider initialization failed")
        }
        let viewController = TrackersViewController(
            trackerDataProvider: dataProvider,
            currentDate: defaultDate
        )
        dataProvider.delegate = viewController
        return viewController
    }
}
