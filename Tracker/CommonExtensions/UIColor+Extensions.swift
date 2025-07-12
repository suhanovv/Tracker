//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Вадим Суханов on 03.07.2025.
//

import UIKit

extension UIColor {
    func toCardColor() -> CardColor? {
        switch self {
        case .cardColor1: return CardColor.cardColor1
        case .cardColor2: return CardColor.cardColor2
        case .cardColor3: return CardColor.cardColor3
        case .cardColor4: return CardColor.cardColor4
        case .cardColor5: return CardColor.cardColor5
        case .cardColor6: return CardColor.cardColor6
        case .cardColor7: return CardColor.cardColor7
        case .cardColor8: return CardColor.cardColor8
        case .cardColor9: return CardColor.cardColor9
        case .cardColor10: return CardColor.cardColor10
        case .cardColor11: return CardColor.cardColor11
        case .cardColor12: return CardColor.cardColor12
        case .cardColor13: return CardColor.cardColor13
        case .cardColor14: return CardColor.cardColor14
        case .cardColor15: return CardColor.cardColor15
        case .cardColor16: return CardColor.cardColor16
        case .cardColor17: return CardColor.cardColor17
        case .cardColor18: return CardColor.cardColor18
        default: return nil
        }
    }
    
    static func fromCardColor(_ color: CardColor) -> UIColor {
        switch color {
        case .cardColor1: return .cardColor1
        case .cardColor2: return .cardColor2
        case .cardColor3: return .cardColor3
        case .cardColor4: return .cardColor4
        case .cardColor5: return .cardColor5
        case .cardColor6: return .cardColor6
        case .cardColor7: return .cardColor7
        case .cardColor8: return .cardColor8
        case .cardColor9: return .cardColor9
        case .cardColor10: return .cardColor10
        case .cardColor11: return .cardColor11
        case .cardColor12: return .cardColor12
        case .cardColor13: return .cardColor13
        case .cardColor14: return .cardColor14
        case .cardColor15: return .cardColor15
        case .cardColor16: return .cardColor16
        case .cardColor17: return .cardColor17
        case .cardColor18: return .cardColor18
        }
    }
}
