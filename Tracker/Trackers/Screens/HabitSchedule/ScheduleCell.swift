//
//  WeekDayElement.swift
//  Tracker
//
//  Created by Вадим Суханов on 21.06.2025.
//

import UIKit

// MARK: - ScheduleCellDelegate
protocol ScheduleCellDelegate: AnyObject {
    func scheduleDidChangeValue(_ day: DayOfWeek, isOn: Bool)
}

// MARK: - ScheduleCell

final class ScheduleCell: UIView {
    private let day: DayOfWeek
    
    weak var delegate: ScheduleCellDelegate?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var checkbox: UISwitch = {
        let view = UISwitch()
        view.onTintColor = .ypBlue
        view.backgroundColor = .ypLightGray
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(with day: DayOfWeek, initialValue: Bool = false, divider: Bool = true) {
        self.day = day
        super.init(frame: .zero)
        label.text = day.fullName()
        checkbox.isOn = initialValue
        setupView()
        setupConstraints()
        if divider {
            viewDivider.isHidden = false
        } else {
            viewDivider.isHidden = true
        }
        
        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews(label, checkbox, viewDivider)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
        ])
        
        setupLabelConstraints()
        setupCheckboxConstraints()
        setupDividerConstraints()
    }
    
    private func setupLabelConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func setupCheckboxConstraints() {
        NSLayoutConstraint.activate([
            checkbox.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkbox.centerYAnchor.constraint(equalTo: label.centerYAnchor),
        ])
    }
    
    private func setupDividerConstraints() {
        NSLayoutConstraint.activate([
            viewDivider.heightAnchor.constraint(equalToConstant: 0.5),
            viewDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configure(with label: String) {
        self.label.text = label
    }
    
    @objc private func toggleCheckbox() {
        delegate?.scheduleDidChangeValue(day, isOn: checkbox.isOn)
    }
}
