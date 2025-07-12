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
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
