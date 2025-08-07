//
//  StatisticsTableViewCell.swift
//  Tracker
//
//  Created by Вадим Суханов on 04.08.2025.
//

import UIKit

// MARK: - StatisticsViewCell
final class StatisticsViewCell: UICollectionViewCell {
    
    var viewModel: StatisticViewModelProtocol? {
        didSet {
            statisticValue.text = "\(viewModel?.value ?? 0)"
            statisticName.text = viewModel?.name
        }
    }
    
    private lazy var statisticValue: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 34, weight: .bold)
        view.textColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statisticName: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .medium)
        view.textColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubviews(statisticValue, statisticName)
    }
    
    private func setupConstraints() {
        let sideInset: CGFloat = 12
        NSLayoutConstraint.activate([
            statisticValue.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            statisticValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInset),
            statisticValue.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            statisticValue.heightAnchor.constraint(equalToConstant: 41),
            statisticValue.bottomAnchor.constraint(equalTo: statisticName.topAnchor, constant: -7),
            
            statisticName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            statisticName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            statisticName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInset),
            statisticName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            statisticName.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
        
    private func setupAppearance() {
        backgroundColor = .ypWhite
        layer.borderWidth = 1
        layer.cornerRadius = Constants.cornerRadius
        
        let gradient = UIImage.gradientImage(
            bounds: bounds,
            colors: [
                UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1),
                UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1),
                UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1)
            ])
        let gradientColor = UIColor(patternImage: gradient)
        layer.borderColor = gradientColor.cgColor
    }
}
