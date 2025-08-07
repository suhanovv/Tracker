//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Вадим Суханов on 10.07.2025.
//
import Foundation

struct TrackerFilterRequest {
    let date: Date
    let dayOfWeek: DayOfWeek
    let name: String?
    let isCompleted: Bool?

    init(date: Date, name: String? = nil, isCompleted: Bool? = nil) {
        self.date = date
        self.dayOfWeek = .dayOfWeekFromDate(date)
        self.name = name
        self.isCompleted = isCompleted
    }
}
