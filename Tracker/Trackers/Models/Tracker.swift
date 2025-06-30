//
//  Tracker.swift
//  Tracker
//
//  Created by Вадим Суханов on 13.06.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [DayOfWeek]
    
    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: [DayOfWeek]) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    init(name: String, color: UIColor, emoji: String, schedule: [DayOfWeek]) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    init(name: String, schedule: [DayOfWeek]) {
        self.id = UUID()
        self.name = name
        self.color = [
            UIColor.cardColor2,
            UIColor.cardColor3,
            UIColor.cardColor5
        ].randomElement() ?? .cardColor1
        self.emoji = "😪"
        self.schedule = schedule
    }
}
