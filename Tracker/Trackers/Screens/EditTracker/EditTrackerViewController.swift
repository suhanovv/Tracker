//
//  New ViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 19.06.2025.
//

import UIKit


// MARK: - NewHabitViewController

final class EditTrackerViewController: UIViewController {
    private enum ViewConstants {
        static let sidesIndent: CGFloat = 16
        static let lementsHeight: CGFloat = 24
        static let activeCreateButtonColor: UIColor = .ypBlack
        static let inactiveCreateButtonColor: UIColor = .ypGrey
    }
    
    private var viewModel: EditTrackerViewModelProtocol
    private let emojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let headers: [String] = ["Emoji", NSLocalizedString("color", comment: "Цвет")]
    
    // MARK: - UI Elements
    lazy private var trackerRecordsLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 32, weight: .bold)
        view.textColor = .ypBlack
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        if let daysCount = viewModel.daysCount {
            view.text = String.localizedStringWithFormat(
                NSLocalizedString("daysCount", comment: ""),
                daysCount)
        }
        return view
    }()
    
    lazy private var trackerNameTextField: TextFieldWithErrorView = {
       let view = TextFieldWithErrorView(placeholder: NSLocalizedString("tracker_name.text_field.placeholder", comment: "Введите название трекера"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.setText(viewModel.trackerName)
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
        let subTitle = viewModel.category?.name
        let view = NewHabitMenuElement(with: NSLocalizedString("edit_tracker.category_button.title", comment: "Категория"), subTitle: subTitle, divider: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleCategoryButtonTapped), for: .touchUpInside)
        view.setSubLabel(subLabel: viewModel.category?.name ?? "")
        return view
    }()
    
    lazy private var scheduleButton: NewHabitMenuElement = {
        let view = NewHabitMenuElement(with: NSLocalizedString("edit_tracker.schedule_button.title", comment: "Расписание"), divider: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleScheduleButtonTapped), for: .touchUpInside)
        view.setSubLabel(subLabel: viewModel.scheduleCaption)
        return view
    }()

    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("edit_tracker.cancel_button.title", comment: "Отменить"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .ypWhite
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var createButton: UIButton = {
        let button = UIButton(type: .system)
        switch viewModel.formType {
            case .add: button.setTitle(NSLocalizedString("edit_tracker.create_button.title", comment: "Создать"), for: .normal)
            case .edit: button.setTitle(NSLocalizedString("edit_tracker.save_button.title", comment: "Сохранить"), for: .normal)
        }
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
        
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
    
    init(viewModel: EditTrackerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.trackerNameErrorBinding = { [weak self] error in
            guard let textField = self?.trackerNameTextField else { return }
            error == nil ? textField.hideError() : textField.showError(error)
        }
        
        viewModel.scheduleCaptionBinding = { [weak self] caption in
            self?.scheduleButton.setSubLabel(subLabel: caption)
        }
        
        viewModel.categoryBinding = { [weak self] category in
            guard
                let self,
                let category = category
            else { return }
            self.categoryButton.setSubLabel(subLabel: category.name)
        }
        
        viewModel.isFormValidBinding = { [weak self] isValid in
            isValid ? self?.createButtonActiveState(): self?.createButtonInactiveState()
        }
    }
    
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
        viewModel.isFormValid ? createButtonActiveState(): createButtonInactiveState()
        if viewModel.formType == .edit {
            view.addSubview(trackerRecordsLabel)
        }
    }
    
    private func setupNavigation() {
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

extension EditTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - NewHabitViewController Constraints

extension EditTrackerViewController {
    private func setupConstraints() {
        if viewModel.formType == .edit {
            setupTrackerRecordsLabelConstraints()
        }
        setupTrackerNameTextFieldConstraints()
        setupMenuButtonWrapperViewConstraints()
        setupMenuStackViewConstraints()
        setupCategoryButtonConstraints()
        setupScheduleButtonConstraints()
        setupButtonsStackViewConstraints()
        setupCollectionViewConstraints()
    }
    
    private func setupTrackerRecordsLabelConstraints() {
        NSLayoutConstraint.activate([
            trackerRecordsLabel.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerRecordsLabel.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidesIndent),
            trackerRecordsLabel.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidesIndent),
        ])
    }
    
    private func setupTrackerNameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            trackerNameTextField.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidesIndent),
            trackerNameTextField.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidesIndent),
        ])
        
        switch viewModel.formType {
            case .add:
                trackerNameTextField.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
            case .edit:
                trackerNameTextField.topAnchor
                    .constraint(equalTo: trackerRecordsLabel.bottomAnchor, constant: 40).isActive = true
        }
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

extension EditTrackerViewController {
    
    @objc private func textFieldDidChange(sender: UITextField) {
        guard let name = sender.text else { return }
        viewModel.trackerNameChanged(name)
    }
    
    @objc private func handleCategoryButtonTapped(_ sender: Any) {
        
        let categoryViewModel = CategoriesViewModel(selectedCategoryId: viewModel.category?.id)
        let vc = CategoryViewController(viewModel: categoryViewModel)
        
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleScheduleButtonTapped(_ sender: Any) {
        
        let vc = ScheduleViewController(selectedDays: viewModel.schedule)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleCancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func handleSaveButtonTapped() {
        viewModel.saveTracker { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate

extension EditTrackerViewController: ScheduleViewControllerDelegate {
    func scheduleChanged(_ schedule: [DayOfWeek]) {
        viewModel.scheduleChanged(schedule)
    }
}

// MARK: - UICollectionViewDataSource
extension EditTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
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
        
        let emoji = emojis[indexPath.item]
        
        cell.configure(with: emoji)
        if viewModel.emoji == emoji {
            cell.activState()
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
        
        return cell
    }
    
    private func colorCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "colorCell",
            for: indexPath
        ) as? ColorCollectionCell else {
            return UICollectionViewCell()
        }
        
        let cardColor = CardColor.allCases[indexPath.item]
        let color = UIColor.fromCardColor(cardColor)
        cell.configure(with: color)
        if viewModel.color == cardColor {
            cell.activState()
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        }
    
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
                viewModel.emojiChanged(emojiCell.getValue())
            case false:
                viewModel.emojiChanged(nil)
        }
    }
    
    private func setColorCellSelection(_ cell: UICollectionViewCell, indexPath: IndexPath, isSelected: Bool) {
        guard let colorCell = cell as? ColorCollectionCell else { return }
        switch isSelected {
            case true:
                viewModel.colorChanged(colorCell.getValue()?.toCardColor())
            case false:
                viewModel.colorChanged(nil)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
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
        0
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

extension EditTrackerViewController {
    func createButtonActiveState() {
        createButton.isEnabled = true
        createButton.backgroundColor = ViewConstants.activeCreateButtonColor
        createButton.setTitleColor(.ypWhite, for: .normal)
    }
    
    func createButtonInactiveState() {
        createButton.isEnabled = false
        createButton.backgroundColor = ViewConstants.inactiveCreateButtonColor
        createButton.setTitleColor(.white, for: .normal)
    }
}

extension EditTrackerViewController: CategoryViewControllerProtocol {
    func categoryDidSelect(_ category: CategoryViewModel, completion: @escaping () -> Void) {
        viewModel.categoryChanged(TrackerCategory(id: category.id, name: category.name))
        completion()
    }
}
