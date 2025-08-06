//
//  CategoryCollectionViewCell.swift
//  Tracker
//
//  Created by Вадим Суханов on 13.07.2025.
//

import UIKit

final class FilterViewCell: UITableViewCell {
    var viewModel: FilterViewModel? {
        didSet {
            guard let viewModel else { return }
            self.label.text = viewModel.name
            self.checkMark.isHidden = !viewModel.isSelected
        }
    }
   
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkMark: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "checkmark"))
        view.tintColor = .ypBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        
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

    private func setupAppearance() {
        backgroundColor = .ypInputGrey
        selectionStyle = .none
    }
    
    private func setupView() {
        contentView.addSubviews(label, checkMark)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            checkMark.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            checkMark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkMark.widthAnchor.constraint(equalToConstant: 24),
            checkMark.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
