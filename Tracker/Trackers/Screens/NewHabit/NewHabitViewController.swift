//
//  New ViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 19.06.2025.
//

import UIKit

// MARK: - NewHabitViewControllerProtocol

protocol NewHabitViewControllerProtocol: AnyObject {
    func showTrackerNameError()
    func hideTrackerNameError()
    func deactivateCreateButton()
    func activateCreateButton()
    func updateSelectedCategoryCaption(_ caption: String)
    func updateSelectedScheduleButtonCaption(_ caption: String)
}


// MARK: - NewHabitViewController

final class NewHabitViewController: UIViewController {
    private enum ViewConstants {
        static let sidesIndent: CGFloat = 16
        static let lementsHeight: CGFloat = 24
        static let activeCreateButtonColor: UIColor = .ypBlack
        static let inactiveCreateButtonColor: UIColor = .ypGrey
        
    }
    
    var presenter: NewHabitViewPresenterProtocol?
    private let emojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    
    private let headers: [String] = ["Emoji", "Цвет"]
    
    
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
    
    lazy private var categoryButton: NewHabitMenuElement = {
        let subTitle = presenter?.getSelectedCategory()?.name
        let view = NewHabitMenuElement(with: "Категория", subTitle: subTitle, divider: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleCategoryButtonTapped), for: .touchUpInside)
        return view
    }()
    
    lazy private var scheduleButton: NewHabitMenuElement = {
        let view = NewHabitMenuElement(with: "Расписание", divider: false)
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        return collectionView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupView()
        setupConstraints()
        setupNavigation()
        
        trackerNameTextField.setDelegate(self)
        setupCollectionView()
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
            trackerNameTextField, menuButtonWrapperView, buttonsStackView, collectionView
        )
    }
    
    private func setupNavigation() {
        title = "Новая привычка"
        navigationItem.hidesBackButton = true
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView
            .register(EmojiCollectionCell.self,
                forCellWithReuseIdentifier: "emojiCell"
            )
        collectionView
            .register(ColorCollectionCell.self,
                forCellWithReuseIdentifier: "colorCell"
            )
        collectionView
            .register(
                CollectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header"
            )
    }
}

// MARK: - UITextFieldDelegate

extension NewHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - NewHabitViewController Constraints

extension NewHabitViewController {
    private func setupConstraints() {
        setupTrackerNameTextFieldConstraints()
        setupMenuButtonWrapperViewConstraints()
        setupMenuStackViewConstraints()
        setupCategoryButtonConstraints()
        setupScheduleButtonConstraints()
        setupButtonsStackViewConstraints()
        setupCollectionViewConstraints()
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
        ])
    }
    
    private func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor
                .constraint(equalTo: menuStackView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor
                .constraint(equalTo: buttonsStackView.topAnchor, constant: -16)
        ])
    }
}

// MARK: - NewHabitViewController Handlers

extension NewHabitViewController {
    
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

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func scheduleChanged(_ schedule: [DayOfWeek]) {
        guard let presenter else { return }
        presenter.scheduleChanged(schedule)
    } 
}

// MARK: - UICollectionViewDataSource
extension NewHabitViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? emojis.count : CardColor.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return emojiCell(for: indexPath)
        case 1:
            return colorCell(for: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    private func emojiCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "emojiCell",
            for: indexPath
        ) as? EmojiCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: emojis[indexPath.item])
        
        
        return cell
    }
    
    private func colorCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "colorCell",
            for: indexPath
        ) as? ColorCollectionCell else {
            return UICollectionViewCell()
        }
        
        let color = UIColor.fromCardColor(CardColor.allCases[indexPath.item])
        cell.configure(with: color)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath
        ) as? CollectionHeaderView else {
            return UICollectionReusableView()
        }
        
        headerView.configure(with: headers[indexPath.section])
        
        return headerView
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        setCellSelection(cell, indexPath: indexPath, isSelected: true)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        setCellSelection(cell, indexPath: indexPath, isSelected: false)
    }
    
    private func setCellSelection(_ cell: UICollectionViewCell, indexPath: IndexPath, isSelected: Bool) {
        guard let cellState = cell as? CollectionViewCellStateProtocol else { return }
        
        switch isSelected {
            case true:
            cellState.activState()
                collectionView.indexPathsForSelectedItems?
                    .filter { $0.section == indexPath.section && $0 != indexPath }
                    .forEach {
                        collectionView.deselectItem(at: $0, animated: false)
                        if let oldCell = collectionView.cellForItem(at: $0) {
                            setCellSelection(oldCell, indexPath: $0, isSelected: false)
                        }
                    }
            case false:
                cellState.inactiveState()
                collectionView.deselectItem(at: indexPath, animated: false)
        }
        
        switch indexPath.section {
            case 0: setEmojiCellSelection(cell, indexPath: indexPath, isSelected: isSelected)
            case 1: setColorCellSelection(cell, indexPath: indexPath, isSelected: isSelected)
            default : break
        }
    }
    
    private func setEmojiCellSelection(_ cell: UICollectionViewCell, indexPath: IndexPath, isSelected: Bool) {
        guard let emojiCell = cell as? EmojiCollectionCell else { return }
        switch isSelected {
            case true:
                presenter?.emojiChanged(emojiCell.getValue())
            case false:
                presenter?.emojiChanged(nil)
        }
    }
    
    private func setColorCellSelection(_ cell: UICollectionViewCell, indexPath: IndexPath, isSelected: Bool) {
        guard let colorCell = cell as? ColorCollectionCell else { return }
        switch isSelected {
            case true:
                presenter?.colorChanged(colorCell.getValue()?.toCardColor())
            case false:
                presenter?.colorChanged(nil)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = CollectionHeaderView()
        headerView.configure(with: headers[section])
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
          withHorizontalFittingPriority: .required,
          verticalFittingPriority: .fittingSizeLevel
        )
    }
}

// MARK: - NewHabitViewControllerProtocol

extension NewHabitViewController: NewHabitViewControllerProtocol {
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
