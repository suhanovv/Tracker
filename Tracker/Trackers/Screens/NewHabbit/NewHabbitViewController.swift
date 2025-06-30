//
//  New ViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 19.06.2025.
//

import UIKit

// MARK: - NewHabbitViewControllerProtocol

protocol NewHabbitViewControllerProtocol: AnyObject {
    func showTrackerNameError()
    func hideTrackerNameError()
    func deactivateCreateButton()
    func activateCreateButton()
    func updateSelectedCategoryCaption(_ caption: String)
    func updateSelectedScheduleButtonCaption(_ caption: String)
}


// MARK: - NewHabbitViewController

final class NewHabbitViewController: UIViewController {
    private enum ViewConstants {
        static let sidesIndent: CGFloat = 16
        static let lementsHeight: CGFloat = 24
        static let activeCreateButtonColor: UIColor = .ypBlack
        static let inactiveCreateButtonColor: UIColor = .ypGrey
        
    }
    
    var presenter: NewHabbitViewPresenterProtocol?
    
    // MARK: - UI Elements
    lazy private var trackerNameTextField: TrackerNameTextFieldView = {
       let view = TrackerNameTextFieldView(placeholder: "Введите название трекера")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return view
    }()
    
    lazy private var menuButtonWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypInputGrey
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .ypInputGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var menuStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [categoryButton, scheduleButton])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var categoryButton: NewHabbitMenuElement = {
        let subTitle = presenter?.getSelectedCategory()?.name
        let view = NewHabbitMenuElement(with: "Категория", subTitle: subTitle, divider: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleCategoryButtonTapped), for: .touchUpInside)
        return view
    }()
    
    lazy private var scheduleButton: NewHabbitMenuElement = {
        let view = NewHabbitMenuElement(with: "Расписание", divider: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleScheduleButtonTapped), for: .touchUpInside)
        return view
    }()

    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.backgroundColor = ViewConstants.inactiveCreateButtonColor
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCreateButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupView()
        setupConstraints()
        setupNavigation()
        
        trackerNameTextField.setDelegate(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupView() {
        menuButtonWrapperView.addSubview(menuStackView)
        view.addSubviews(
            trackerNameTextField, menuButtonWrapperView, buttonsStackView
        )
    }
    
    private func setupNavigation() {
        title = "Новая привычка"
        navigationItem.hidesBackButton = true
    }
}

// MARK: - UITextFieldDelegate

extension NewHabbitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - NewHabbitViewController Constraints

extension NewHabbitViewController {
    private func setupConstraints() {
        setupTrackerNameTextFieldConstraints()
        setupMenuButtonWrapperViewConstraints()
        setupMenuStackViewConstraints()
        setupCategoryButtonConstraints()
        setupScheduleButtonConstraints()
        setupButtonsStackViewConstraints()
    }
    
    private func setupTrackerNameTextFieldConstraints() {
            NSLayoutConstraint.activate([
                trackerNameTextField.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                trackerNameTextField.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidesIndent),
                trackerNameTextField.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidesIndent),

            ])
        }
    
    private func setupMenuButtonWrapperViewConstraints() {
        NSLayoutConstraint.activate([
            menuButtonWrapperView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            menuButtonWrapperView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidesIndent),
            menuButtonWrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidesIndent),
        ])
    }
    
    private func setupMenuStackViewConstraints() {
        NSLayoutConstraint.activate([
            menuStackView.topAnchor.constraint(equalTo: menuButtonWrapperView.topAnchor),
            menuStackView.bottomAnchor.constraint(equalTo: menuButtonWrapperView.bottomAnchor),
            menuStackView.leadingAnchor.constraint(equalTo: menuButtonWrapperView.leadingAnchor, constant: ViewConstants.sidesIndent),
            menuStackView.trailingAnchor.constraint(equalTo: menuButtonWrapperView.trailingAnchor, constant: -ViewConstants.sidesIndent),
        ])
    }
    
    private func setupCategoryButtonConstraints() {
        NSLayoutConstraint.activate([
            categoryButton.leadingAnchor.constraint(equalTo: menuStackView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: menuStackView.trailingAnchor),
        ])
    }
    
    private func setupScheduleButtonConstraints() {
        NSLayoutConstraint.activate([
            scheduleButton.leadingAnchor.constraint(equalTo: menuStackView.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: menuStackView.trailingAnchor),
        ])
    }
    
    private func setupButtonsStackViewConstraints() {
        let leadingTrailing: CGFloat = 20
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailing),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailing),
            buttonsStackView.bottomAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                    constant: -16
                ),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ]
)
    }
}

// MARK: - NewHabbitViewController Handlers

extension NewHabbitViewController {
    
    @objc private func textFieldDidChange(sender: UITextField) {
        guard
            let name = sender.text,
            let presenter
        else { return }
        presenter.trackerNameChanged(name)
    }
    
    @objc private func handleCategoryButtonTapped(_ sender: Any) {
        // TODO: Заглушка под реализацию в следующих спринтах
        print(sender)
    }
    
    @objc private func handleScheduleButtonTapped(_ sender: Any) {
        guard let presenter else { return }
        let vc = ScheduleViewController(selectedDays: presenter.getSelectedSchedule())
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleCancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func handleCreateButtonTapped() {
        guard let presenter else { return }
        presenter.createNewTracker { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate

extension NewHabbitViewController: ScheduleViewControllerDelegate {
    func scheduleChanged(_ schedule: [DayOfWeek]) {
        guard let presenter else { return }
        presenter.scheduleChanged(schedule)
    } 
}

// MARK: - NewHabbitViewControllerProtocol

extension NewHabbitViewController: NewHabbitViewControllerProtocol {
    func showTrackerNameError() {
        trackerNameTextField.showError()
    }

    func hideTrackerNameError() {
        trackerNameTextField.hideError()
    }

    func deactivateCreateButton() {
        createButton.isEnabled = false
        createButton.backgroundColor = ViewConstants.inactiveCreateButtonColor
    }

    func activateCreateButton() {
        createButton.isEnabled = true
        createButton.backgroundColor = ViewConstants.activeCreateButtonColor
    }
    
    func updateSelectedCategoryCaption(_ caption: String) {
        categoryButton.setSubLabel(subLabel: caption)
    }
    
    func updateSelectedScheduleButtonCaption(_ caption: String) {
        scheduleButton.setSubLabel(subLabel: caption)
    }
    
}
