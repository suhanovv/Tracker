//
//  ScheduleValidator.swift
//  Tracker
//
//  Created by Вадим Суханов on 28.06.2025.
//

import Foundation

final class ColorValidator {
    enum ValidationResult {
        case empty
        case valid
    }
    static func validate(_ cardColor: CardColor?) -> ValidationResult {
        if cardColor != nil {
            return .valid
        }
        return .empty
    }
}
