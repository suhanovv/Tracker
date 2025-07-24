//
//  TrackerNameValidator.swift
//  Tracker
//
//  Created by Вадим Суханов on 28.06.2025.
//

import Foundation

final class TrackerNameValidator {
    
    enum ValidationResult {
        case empty
        case tooLong
        case valid
        
        var resultDescription: String {
            switch self {
                case .empty: return "Обязательное поле"
                case .tooLong: return "Ограничение 38 символов"
                default: return ""
            }
        }
    }
    
    static func validate(_ value: String) -> ValidationResult {
        
        switch value.count {
            case 0: return .empty
            case 39...: return .tooLong
            default: return .valid
        }
    }
}
