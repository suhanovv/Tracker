//
//  DayOfWeek.swift
//  Tracker
//
//  Created by Вадим Суханов on 29.06.2025.
//

import Foundation

enum DayOfWeek: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    static var allCases: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    func shortName() -> String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    static func dayOfWeekFromDate(_ date: Date) -> DayOfWeek {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        
        let weekdaynumber = calendar.component(.weekday, from: date)
        let weekdaystring = calendar.standaloneWeekdaySymbols[weekdaynumber - 1]

        return .init(rawValue: weekdaystring.capitalized) ?? .monday
    }
}
