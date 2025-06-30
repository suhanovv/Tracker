//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Вадим Суханов on 13.06.2025.
//

import Foundation

struct TrackerCategory {
    let id: UUID
    let name: String
    let trackers: [Tracker]
    
    init(id: UUID, name: String, trackers: [Tracker]) {
        self.id = id
        self.name = name
        self.trackers = trackers
    }
    
    init(name: String, trackers: [Tracker]) {
        self.id = UUID()
        self.name = name
        self.trackers = trackers
    }
    
    func addTracker(_ tracker: Tracker) -> Self {
        return .init(id: self.id, name: self.name, trackers: self.trackers + [tracker])
    }
}
