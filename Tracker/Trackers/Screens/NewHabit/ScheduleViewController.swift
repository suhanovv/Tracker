//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 22.06.2025.
//

import UIKit

// MARK: - ScheduleViewControllerDelegate
protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleChanged(_ schedule: [DayOfWeek])
}

// MARK: - ScheduleViewController
final class ScheduleViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    
    private var selectedDays: Set<DayOfWeek> = []
    
    private lazy var weekDaysStackViewWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .ypInputGrey
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .ypInputGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var weekDaysStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.  ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOkButtonTapped), for: .touchUpInside)
        return button
    }()

    init(selectedDays: [DayOfWeek]) {
        self.selectedDays = Set(selectedDays)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        setupConsraints()
        setupNavigation()
        setupAppearance()
    }
    
    @objc private func handleOkButtonTapped() {
        delegate?.scheduleChanged(Array(selectedDays))
        navigationController?.popViewController(animated: true)
    }
    
    private func makeViews() {
        weekDaysStackViewWrapper.addSubview(weekDaysStackView)
        view.addSubviews(weekDaysStackViewWrapper, okButton)
        
        DayOfWeek.allCases.forEach { day in
            let divider = day == .sunday ? false : true
            let isSelected = selectedDays.contains(day)
            let view = ScheduleCell(
                with: day,
                initialValue: isSelected,
                divider: divider
            )
            view.delegate = self
            weekDaysStackView.addArrangedSubview(view)
        }
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupConsraints() {
        NSLayoutConstraint.activate([
            weekDaysStackViewWrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            weekDaysStackViewWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekDaysStackViewWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekDaysStackViewWrapper.heightAnchor.constraint(equalToConstant: 525),
            
            weekDaysStackView.topAnchor
                .constraint(equalTo: weekDaysStackViewWrapper.topAnchor),
            weekDaysStackView.leadingAnchor
                .constraint(equalTo: weekDaysStackViewWrapper.leadingAnchor, constant: 16),
            weekDaysStackView.trailingAnchor
                .constraint(equalTo: weekDaysStackViewWrapper.trailingAnchor, constant: -16),
            weekDaysStackView.bottomAnchor
                .constraint(equalTo: weekDaysStackViewWrapper.bottomAnchor),
            
            okButton.heightAnchor.constraint(equalToConstant: 60),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupNavigation() {
        title = "Расписание"
        navigationItem.hidesBackButton = true
    }
}


// MARK: - ScheduleCellDelegate

extension ScheduleViewController: ScheduleCellDelegate {
    func scheduleDidChangeValue(_ day: DayOfWeek, isOn: Bool) {
        if isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
        
    }

    
}
