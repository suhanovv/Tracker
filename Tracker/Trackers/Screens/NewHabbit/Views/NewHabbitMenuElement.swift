//
//  NewHabbitMenuElement.swift
//  Tracker
//
//  Created by Вадим Суханов on 21.06.2025.
//

import UIKit

// MARK: - NewHabbitMenuElement

final class NewHabbitMenuElement: UIControl {
    
    lazy private var label: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy private var subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGrey
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var labelWrapper: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, subLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy private var chevroneImageView: UIImageView = {
        let imgView = UIImageView(image: .buttonChevroneLeft)
        imgView.tintColor = .ypGrey
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy private var viewDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(with title: String, subTitle: String? = nil, divider: Bool = true) {
        super.init(frame: .zero)
        label.text = title
        subLabel.text = subTitle
        setupView()
        setupConstraints()
        if divider {
            viewDivider.isHidden = false
        } else {
            viewDivider.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews(labelWrapper, chevroneImageView, viewDivider)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
        ])
        
        setupLabelsConstraints()
        setupChevroneConstraint()
        setupDividerConstraint()
    }
    
    private func setupLabelsConstraints() {
        NSLayoutConstraint.activate([
            labelWrapper.centerYAnchor.constraint(equalTo: chevroneImageView.centerYAnchor),
            labelWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelWrapper.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: labelWrapper.leadingAnchor),
            subLabel.leadingAnchor.constraint(equalTo: labelWrapper.leadingAnchor),
        ])
    }
    
    private func setupChevroneConstraint() {
        NSLayoutConstraint.activate([
            chevroneImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevroneImageView.widthAnchor.constraint(equalToConstant: 24),
            chevroneImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func setupDividerConstraint() {
        NSLayoutConstraint.activate([
            viewDivider.heightAnchor.constraint(equalToConstant: 0.5),
            viewDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configure(with label: String, subLabel: String?) {
        self.label.text = label
        if subLabel != nil {
            self.subLabel.text = subLabel
        }
    }
    
    func setSubLabel(subLabel: String) {
        self.subLabel.text = subLabel
    }
 
}
