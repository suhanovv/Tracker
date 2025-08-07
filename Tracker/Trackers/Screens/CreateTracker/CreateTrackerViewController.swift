//
//  CreateTrackerView.swift
//  Tracker
//
//  Created by Вадим Суханов on 18.06.2025.
//

import UIKit

// MARK: - CreateTrackerViewController

final class CreateTrackerViewController: UIViewController {
    private enum ViewConstants {
        static let buttonHeihgt: CGFloat = 60
        static let sideIndent: CGFloat = 20
    }
    
    private lazy var habitButton: UIButton = makeButton(title: NSLocalizedString("habitButtonTitle", comment: "Привычка"))
    private lazy var unregularEventButton: UIButton = makeButton(title: NSLocalizedString("UnregularEventButtonTitle", comment: "Нерегулярное событие"))
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [habitButton, unregularEventButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupView()
        setupConstraints()
        setupNavigation()
        setupButtonHandlers()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupView() {
        view.addSubview(stack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: ViewConstants.buttonHeihgt),
            unregularEventButton.heightAnchor.constraint(equalToConstant: ViewConstants.buttonHeihgt),
            
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sideIndent),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sideIndent),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func makeButton(title: String) -> UIButton {
        let button = UIButton(frame: .zero)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func setupNavigation() {
        title = NSLocalizedString("createTrackerTitle", comment: "Создание трекера")
        navigationItem.hidesBackButton = true
    }
    
    private func setupButtonHandlers() {
        habitButton.addTarget(self, action: #selector(handleHabitButtonTapped), for: .touchUpInside)
    }
    
    @objc private func handleHabitButtonTapped() {
        let newHabitVC = NewHabitViewControlllerFactory().make()
        newHabitVC.title = NSLocalizedString("newHabitTitle", comment: "Новая привычка")
        navigationController?.pushViewController(newHabitVC, animated: true)
    }
}
