//
//  TrackerCell.swift
//  Tracker
//
//  Created by Вадим Суханов on 15.06.2025.
//

import UIKit


// MARK: - TrackerCardPreview

final class TrackerCardPreview: UIViewController {
    
    var viewModel: TrackerCardViewModelProtocol? {
        didSet {
            nameLabel.text = viewModel?.trackerName
            emojiLabel.text = viewModel?.emoji
            
            if let color = viewModel?.cardColor {
                quantityView.backgroundColor = UIColor.fromCardColor(color)
            }
        }
    }
    
    private enum ViewConstants {
        static let sidesIndent: CGFloat = 12
        static let emojiSize: CGFloat = 24
        static let plusButtonSize: CGFloat = 32
    }
    
    // MARK: - View Elements
    
    lazy private var quantityView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = .emojiBackground
        label.layer.cornerRadius = ViewConstants.emojiSize / 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var nameLabel: BottomAlignedLabel = {
        let label = BottomAlignedLabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override func viewDidLoad() {
        setupAppearance()
        setupView()
        setupConstraints()
    }
}
 

// MARK: - TrackerCard UI Configuration

extension TrackerCardPreview {
    
    private func setupAppearance() {
        view.backgroundColor = .clear
    }
    
    private func setupView() {
        quantityView.addSubviews(emojiLabel, nameLabel)
        view.addSubview(quantityView)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        setupQuantityViewConstraint()
        setupEmojiViewConstraint()
        setupNameLabelConstraint()
    }
    
    private func setupQuantityViewConstraint() {
        NSLayoutConstraint.activate([
            quantityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            quantityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            quantityView.topAnchor.constraint(equalTo: view.topAnchor),
            quantityView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmojiViewConstraint() {
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: ViewConstants.sidesIndent),
            emojiLabel.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: ViewConstants.sidesIndent),
            emojiLabel.widthAnchor.constraint(equalToConstant: ViewConstants.emojiSize),
            emojiLabel.heightAnchor.constraint(equalTo: emojiLabel.widthAnchor, multiplier: 1),
        ])
    }
    
    private func setupNameLabelConstraint() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: ViewConstants.sidesIndent),
            nameLabel.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: -ViewConstants.sidesIndent),
            nameLabel.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
        ])
    }
}
