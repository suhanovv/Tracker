//
//  ScheduleValidator.swift
//  Tracker
//
//  Created by Вадим Суханов on 28.06.2025.
//

import Foundation

final class EmojiValidator {
    enum ValidationResult {
        case empty
        case valid
    }
    static func validate(_ emoji: String?) -> ValidationResult {
        if let emoji {
            return !emoji.isEmpty ? .valid : .empty
        }
        return .empty
    }
}
