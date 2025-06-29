//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Вадим Суханов on 28.06.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
