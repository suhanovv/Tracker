//
//  AnalyticService.swift
//  Tracker
//
//  Created by Вадим Суханов on 03.08.2025.
//

import Foundation
import AppMetricaCore

enum Screen: String {
    case main = "Main"
}

enum ClickItem: String {
    case addTracker = "add_tracker"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}

enum Event {
    case open(screen: Screen)
    case close(screen: Screen)
    case click(screen: Screen, item: ClickItem)
}

final class AnalyticService {
    static func send(event: Event) {
        
        let (eventName, params) = switch event {
            case .open(screen: let screen): ("open", ["screen": screen.rawValue])
            case .close(screen: let screen): ("close", ["screen": screen.rawValue])
            case .click(screen: let screen, item: let item): ("click", [ "screen": screen.rawValue, "item": item.rawValue])
        }
        
        AppMetrica.reportEvent(name: eventName, parameters: params, onFailure: { error in
            print("ANALYTICS REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
