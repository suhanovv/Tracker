//
//  TrackersFilter.swift
//  Tracker
//
//  Created by Вадим Суханов on 01.08.2025.
//

import Foundation

enum TrackersFilter: CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    func translatedTitle() -> String {
        switch self {
            case .all:
                return NSLocalizedString("filter_all_trackers", comment: "Все трекеры")
            case .today:
                return NSLocalizedString("filter_trackers_for_today", comment: "Трекеры на сегодня")
            case .completed:
                return NSLocalizedString("filter_completed_trackers", comment: "Завершенные")
            case .uncompleted:
                return NSLocalizedString("filter_uncompleted_trackers", comment: "Не завершенные")
        }
    }
}
