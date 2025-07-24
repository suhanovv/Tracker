//
//  CategoryCollectionViewCell.swift
//  Tracker
//
//  Created by Вадим Суханов on 13.07.2025.
//

import UIKit

final class CategoryViewCell: UITableViewCell {
    
    var viewModel: CategoryViewModel? {
        didSet {
            viewModel?.nameBinding = { [weak self] name in
                self?.label.text = name
            }
            viewModel?.isSelectedBinding = { [weak self] isSelected in
                self?.checkMark.isHidden = !isSelected
            }
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.text = viewModel?.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkMark: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "checkmark"))
        view.tintColor = .ypBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        if let viewModel {
            view.isHidden = viewModel.isSelected
        }
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel?.nameBinding = { [weak self] name in
            self?.label.text = name
        }
        viewModel?.isSelectedBinding = { [weak self] isSelected in
            self?.checkMark.isHidden = !isSelected
        }
    }
    
    private func setupAppearance() {
        backgroundColor = .ypInputGrey
    }
    
    private func setupView() {
        contentView.addSubviews(label, checkMark)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            checkMark.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            checkMark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkMark.widthAnchor.constraint(equalToConstant: 24),
            checkMark.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
