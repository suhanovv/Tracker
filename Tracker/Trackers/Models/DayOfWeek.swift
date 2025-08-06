//
//  DayOfWeek.swift
//  Tracker
//
//  Created by Вадим Суханов on 29.06.2025.
//

import Foundation


public enum DayOfWeek: String, CaseIterable, Codable {

    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    public static var allCases: [DayOfWeek] = [
        .monday,
        .tuesday,
        .wednesday,
        .thursday,
        .friday,
        .saturday,
        .sunday
    ]
    
    func shortName() -> String {
        switch self {
        case .monday: return NSLocalizedString("weekday.monday.short", comment: "Понедельник")
        case .tuesday: return NSLocalizedString("weekday.tuesday.short", comment: "Вторник")
        case .wednesday: return NSLocalizedString("weekday.thursday.short", comment: "Среда")
        case .thursday: return NSLocalizedString("weekday.wednesday.short", comment: "Четверг")
        case .friday: return NSLocalizedString("weekday.friday.short", comment: "Пятница")
        case .saturday: return NSLocalizedString("weekday.saturday.short", comment: "Суббота")
        case .sunday: return NSLocalizedString("weekday.sunday.short", comment: "Воскресенье")
        }
    }
    
    func fullName() -> String {
        switch self {
        case .monday: return NSLocalizedString("weekday.monday.full", comment: "Понедельник")
        case .tuesday: return NSLocalizedString("weekday.tuesday.full", comment: "Вторник")
        case .wednesday: return NSLocalizedString("weekday.thursday.full", comment: "Среда")
        case .thursday: return NSLocalizedString("weekday.wednesday.full", comment: "Четверг")
        case .friday: return NSLocalizedString("weekday.friday.full", comment: "Пятница")
        case .saturday: return NSLocalizedString("weekday.saturday.full", comment: "Суббота")
        case .sunday: return NSLocalizedString("weekday.sunday.full", comment: "Воскресенье")
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
