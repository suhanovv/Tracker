//
//  TrackerCell.swift
//  Tracker
//
//  Created by Вадим Суханов on 15.06.2025.
//

import UIKit

// MARK: - TrackerCardDelegateProtocol

protocol TrackerCardDelegateProtocol: AnyObject {
    func didCheckTracker(_ tracker: Tracker)
    func didUncheckTracker(_ tracker: Tracker)
}

// MARK: - TrackerCard

final class TrackerCard: UICollectionViewCell {
    
    weak var delegate: TrackerCardDelegateProtocol?
    
    private enum ViewConstants {
        static let sidesIndent: CGFloat = 12
        static let emojiSize: CGFloat = 24
        static let plusButtonSize: CGFloat = 32
    }
    
    // MARK: - Properties
    private var tracker: Tracker?
    private var checkedDaysCount: Int = 0
    private var isChecked: Bool = false
    private var isActive: Bool = true
    
    // MARK: - View Elements
    lazy private var cardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [quantityView, trackerView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy private var quantityView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardColor1
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "😻"
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
        label.text = "Кошка заслонила камеру на созвоне"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var trackerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var daysLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12 дней"
        return label
    }()
    
    lazy private var plusButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = ViewConstants.plusButtonSize / 2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = isActive
        button.addTarget(self, action: #selector(handlePlusButtonTapped), for: .touchUpInside)
        
        return button
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
    
    @objc private func handlePlusButtonTapped() {
        guard let tracker else { return }
        
        if isChecked {
            delegate?.didUncheckTracker(tracker)
        } else {
            delegate?.didCheckTracker(tracker)
        }
    }
    
    private func uncheckedButtonState(_ tracker: Tracker) {
        plusButton.backgroundColor = UIColor.fromCardColor(tracker.color).withAlphaComponent(1)
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    private func checkedButtonState(_ tracker: Tracker) {
        plusButton.backgroundColor = UIColor.fromCardColor(tracker.color).withAlphaComponent(0.3)
        plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
    }
}
 

// MARK: - TrackerCard UI Configuration

extension TrackerCard {
    
    private func setupAppearance() {
        contentView.backgroundColor = .ypWhite
    }
    
    private func setupView() {
        quantityView.addSubviews(emojiLabel, nameLabel)
        trackerView.addSubviews(daysLabel, plusButton)
        contentView.addSubview(cardStackView)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        setupCardViewConstraint()
        setupQuantityViewConstraint()
        setupEmojiViewConstraint()
        setupNameLabelConstraint()
        setupDaysLabelConstraint()
        setupPlusButtonConstraint()
        
    }
    
    private func setupCardViewConstraint() {
        NSLayoutConstraint.activate([
            cardStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupQuantityViewConstraint() {
        NSLayoutConstraint.activate([
            quantityView.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    private func setupEmojiViewConstraint() {
        NSLayoutConstraint.activate(
[
            emojiLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: ViewConstants.sidesIndent),
            emojiLabel.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: ViewConstants.sidesIndent),
            emojiLabel.widthAnchor.constraint(equalToConstant: ViewConstants.emojiSize),
            emojiLabel.heightAnchor.constraint(equalTo: emojiLabel.widthAnchor, multiplier: 1),
        ]
)
    }
    
    private func setupNameLabelConstraint() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: ViewConstants.sidesIndent),
            nameLabel.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: -ViewConstants.sidesIndent),
            nameLabel.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
        ])
    }
    
    private func setupDaysLabelConstraint() {
        NSLayoutConstraint.activate([
            daysLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: ViewConstants.sidesIndent),
            daysLabel.widthAnchor.constraint(equalToConstant: 101),
            daysLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
        ])
    }
    
    private func setupPlusButtonConstraint() {
        NSLayoutConstraint.activate([
            plusButton.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -ViewConstants.sidesIndent),
            plusButton.widthAnchor.constraint(equalToConstant: ViewConstants.plusButtonSize),
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor, multiplier: 1),
            plusButton.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 8)
            
        ])
    }
}

// MARK: - TrackerCard data population
extension TrackerCard {
    
    func configure(tracker: Tracker, isChecked: Bool, isActive: Bool = true) {
        self.tracker = tracker
        self.isChecked = isChecked
        daysLabel.text = String.pluralize(days: tracker.countChecks)
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        quantityView.backgroundColor = UIColor.fromCardColor(tracker.color)
        plusButton.isEnabled = isActive
        if isChecked {
            checkedButtonState(tracker)
        } else {
            uncheckedButtonState(tracker)
        }
        
    }
}
