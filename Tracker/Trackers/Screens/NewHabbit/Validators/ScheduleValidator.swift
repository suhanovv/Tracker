//
//  ScheduleValidator.swift
//  Tracker
//
//  Created by Вадим Суханов on 28.06.2025.
//

import Foundation

final class ScheduleValidator {
    enum ValidationResult {
        case empty
        case valid
    }
    static func validate(_ schedule: [DayOfWeek]) -> ValidationResult {
        return !schedule.isEmpty ? .valid : .empty
    }
}
