//
//  EmojiCollectionCell.swift
//  Tracker
//
//  Created by Вадим Суханов on 03.07.2025.
//

import UIKit

final class ColorCollectionCell: UICollectionViewCell {
    
    private var color: UIColor?
    
    private lazy var colorSquare: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        contentView.backgroundColor = .ypWhite
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 3
    }
    
    private func setupView() {
        contentView.addSubview(colorSquare)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorSquare.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorSquare.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorSquare.heightAnchor.constraint(equalToConstant: 40),
            colorSquare.widthAnchor.constraint(equalTo: colorSquare.heightAnchor),
        ])
    }
    
    func configure(with color: UIColor) {
        self.color = color
        colorSquare.backgroundColor = color
        inactiveState()
    }
    
    func getValue() -> UIColor? {
        return color
    }
}

extension ColorCollectionCell: CollectionViewCellStateProtocol {
    func activState() {
        contentView.layer.borderColor = color?.withAlphaComponent(0.3).cgColor
    }
    
    func inactiveState() {
        contentView.layer.borderColor = UIColor.ypWhite.cgColor
    }
}
