//
//  FilterViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 29.07.2025.
//

import Foundation

final class FilterViewModel {
    var name: String {
        filter.translatedTitle()
    }
    private(set) var isSelected: Bool = false
    private(set) var filter: TrackersFilter
    
    init(filter: TrackersFilter, isSelected: Bool = false) {
        self.filter = filter
        switch filter {
            case .all, .today:
                self.isSelected = false
            default:
                self.isSelected = isSelected
        }
    }
}
