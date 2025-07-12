//
//  TrackerEntity.swift
//  Tracker
//
//  Created by Вадим Суханов on 06.07.2025.
//

import Foundation

extension TrackerEntity: DomainModelProtocol {
    func toDomainModel() -> Tracker? {
        guard
            let id = trackerId,
            let name = name,
            let color = color,
            let cardColor = CardColor(rawValue: color),
            let emoji = emoji,
            let schedule = schedule?.components(separatedBy: ",").map({
                DayOfWeek(rawValue: $0) ?? .monday
            }),
            let records
        else { return nil }
        
        return Tracker(
            id: id,
            name: name,
            color: cardColor,
            emoji: emoji,
            schedule: schedule,
            countChecks: records.count
        )
    }
}

