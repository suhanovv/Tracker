//
//  BottomAlignedLabel.swift
//  Tracker
//
//  Created by Вадим Суханов on 30.06.2025.
//

import UIKit

class BottomAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        var newRect = rect
        if numberOfLines != 1 {
            let textSize = self.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
            newRect.origin.y = rect.height - textSize.height
            newRect.size.height = textSize.height
        }
        super.drawText(in: newRect)
    }
}
