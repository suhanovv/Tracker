//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Вадим Суханов on 10.07.2025.
//

struct TrackerFilter {
    let dayOfWeek: DayOfWeek
    let name: String?
    
    init(dayOfWeek: DayOfWeek) {
        self.dayOfWeek = dayOfWeek
        name = nil
    }
    
    init(dayOfWeek: DayOfWeek, name: String) {
        self.dayOfWeek = dayOfWeek
        self.name = name
    }
}
