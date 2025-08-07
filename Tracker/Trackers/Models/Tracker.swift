//
//  Tracker.swift
//  Tracker
//
//  Created by Вадим Суханов on 13.06.2025.
//

import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: CardColor
    let emoji: String
    let schedule: [DayOfWeek]
    let countChecks: Int
    let category: TrackerCategory?
    
    init(
        id: UUID,
        name: String,
        color: CardColor,
        emoji: String,
        schedule: [DayOfWeek],
        countChecks: Int,
        category: TrackerCategory? = nil
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.countChecks = countChecks
        self.category = category
    }
    
    init(
        name: String,
        color: CardColor,
        emoji: String,
        schedule: [DayOfWeek],
        category: TrackerCategory? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.countChecks = 0
        self.category = category
    }
}
