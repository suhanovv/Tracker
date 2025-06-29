//
//  TrackerSegmentHeader.swift
//  Tracker
//
//  Created by Вадим Суханов on 17.06.2025.
//

import UIKit

final class TrackerCategoryHeaderView: UICollectionReusableView {
    private enum ViewConstants {
        static let sidesIndent: CGFloat = 28
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.text = "Радостные мелочи"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.sidesIndent),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConstants.sidesIndent),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    func configure(with title: String) {
        self.titleLabel.text = title
    }
}
