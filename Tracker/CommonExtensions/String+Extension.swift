//
//  String+Extension.swift
//  Tracker
//
//  Created by Вадим Суханов on 29.06.2025.
//

import Foundation

extension String {
    static func pluralize(days: Int) -> String {
        let lastDigit = days % 10
        let lastTwoDigits = days % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "\(days) дней"
        }
        switch lastDigit {
        case 1: return "\(days) день"
        case 2, 3, 4: return "\(days) дня"
        default: return "\(days) дней"
        }
    }
}
