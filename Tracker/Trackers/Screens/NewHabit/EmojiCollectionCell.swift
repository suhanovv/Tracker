//
//  EmojiCollectionCell.swift
//  Tracker
//
//  Created by Вадим Суханов on 03.07.2025.
//

import UIKit

final class EmojiCollectionCell: UICollectionViewCell {
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.layer.cornerRadius = 16
    }
    
    private func setupView() {
        contentView.addSubview(emojiLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    func getValue() -> String? {
        return emojiLabel.text
    }
}


extension EmojiCollectionCell: CollectionViewCellStateProtocol {
    func activState() {
        contentView.backgroundColor = .ypLightGray
    }
    
    func inactiveState() {
        contentView.backgroundColor = .ypWhite
    }
}
