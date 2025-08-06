//
//  ViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 12.06.2025.
//

import UIKit

// MARK: - TrackersViewController

final class TrackersViewController: UIViewController {
    
    private enum ViewConstants {
        static let sidesIndent: CGFloat = 16
        static let columnsCount: CGFloat = 2
        static let interitemSpacing: CGFloat = 9
    }
    
    private let cellHeight: CGFloat = 148

    // MARK: - Properties
    
    private var viewModel: TrackersViewModelProtocol
    
    init(viewModel: TrackersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.selectedDateBinding = {[weak self] date in
            self?.collectionView.reloadData()
            self?.updateEmptyLogoVisibility()
            self?.dateButton.setDate(date, animated: true)
        }
        viewModel.searchTextBinding = {[weak self] _ in
            self?.collectionView.reloadData()
            self?.updateEmptyLogoVisibility()
        }
        viewModel.trackersChangedBinding = {[weak self] update in
            guard let self else { return }
            self.collectionView.performBatchUpdates {
                self.collectionView.insertSections(update.insertedSections)
                self.collectionView.reloadSections(update.updatedSections)
                self.collectionView.deleteSections(update.deletedSections)
                self.collectionView.insertItems(at: Array(update.insertedIndexes))
                self.collectionView.reloadItems(at: Array(update.updatedIndexes))
                self.collectionView.deleteItems(at: Array(update.deletedIndexes))
            }
            
        }
        viewModel.categoriesChangedBinding = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.selectedFilterBinding = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.trackersSearchResultBinding = { [weak self] _ in
            self?.updateEmptyLogoVisibility()
            self?.updateFilterButtonVisibility()
        }
    }
    
    // MARK: - UI elements
    
    private lazy var dateButton: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .ypBlack
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var emptyTrackersLogo: EmptyCollectionLogoView = {
        let emptyView = EmptyCollectionLogoView(
            labelText: NSLocalizedString("emptyTrackersLogoLabelText", comment: "Что будем отслеживать?"),
            resource: .emptyTrackersLogo
        )
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 66, right: 0)
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        return collectionView
    }()
    
    private lazy var searchBar: UISearchTextField = {
        let view = UISearchTextField()
        view.placeholder = NSLocalizedString("search", comment: "Поиск")
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .ypInputGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addTarget(self, action: #selector(searchBarTextDidChange), for: .editingChanged)
        view.delegate = self

        return view
    }()
    
    lazy private var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitle(NSLocalizedString("filters", comment: "Фильтры"), for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Handlers
    
    @objc private func addButtonTapped() {
        let createTrackerVC = CreateTrackerViewController()
        let navigation = UINavigationController(rootViewController: createTrackerVC)
        AnalyticService.send(event: .click(screen: .main, item: .addTracker))
        
        present(navigation, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.changeDate(Calendar.current.startOfDay(for: sender.date))
    }
    
    @objc func searchBarTextDidChange(_ sender: UISearchTextField) {
        viewModel.changeSearchText(sender.text ?? "")
    }
    
    @objc func filterButtonTapped() {
        let filtersViewController = FiltersViewController(viewModel: viewModel.filtersViewModel)
        let navigation = UINavigationController(rootViewController: filtersViewController)
        AnalyticService.send(event: .click(screen: .main, item: .filter))
        present(navigation, animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidAppear(_ animated: Bool) {
        AnalyticService.send(event: .open(screen: .main))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AnalyticService.send(event: .close(screen: .main))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupView()
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        setupEmptyTrackersLogo()
    }

    private func updateEmptyLogoVisibility() {
        switch viewModel.trackersSearchResult {
            case .notEmpty: emptyTrackersLogo.hide()
            case .noSearchResult:
                emptyTrackersLogo
                    .show(labelText: NSLocalizedString("filters.noSearchResult", comment: "Ничего не найдено"), resource: .notFoundTrackersLogo)
            case .noTrackers:
                emptyTrackersLogo.show(labelText: NSLocalizedString("emptyTrackersLogoLabelText", comment: "Что будем отслеживать?"), resource: .emptyTrackersLogo)
        }
    }
    
    private func updateFilterButtonVisibility() {
        switch viewModel.trackersSearchResult {
            case .notEmpty, .noSearchResult: filterButton.isHidden = false
            case .noTrackers: filterButton.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection(section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "trackerCell",
                for: indexPath) as? TrackerCard,
            let trackerViewModel = viewModel.trackerViewModelAt(indexPath)
        else { return UICollectionViewCell()}
        
        cell.viewModel = trackerViewModel

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        makeTargetPreview(collectionView: collectionView, configuration: configuration)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        makeTargetPreview(collectionView: collectionView, configuration: configuration)
    }
    
    private func makeTargetPreview(collectionView: UICollectionView, configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? TrackerCard else { return nil }
        let parameters = UIPreviewParameters()
        let cellWidth = getCellWidth(collectionView: collectionView)
        parameters.visiblePath = .init(
            roundedRect: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight),
            cornerRadius: Constants.cornerRadius
        )
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: selectedCell.contentView, parameters: parameters)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: { [weak self] in
                guard let self else { return nil }
                let preview = TrackerCardPreview()
                preview.viewModel = self.viewModel.trackerViewModelAt(indexPath)
                let cellWidth = getCellWidth(collectionView: self.collectionView)
                preview.preferredContentSize = CGSize(width: cellWidth, height: 90)
                
                return preview
            },
            actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: NSLocalizedString("context_menu_trackers_edit", comment: "Редактировать")) { [weak self] _ in
                    guard let tracker = self?.viewModel.editTrackerViewModelAt(indexPath) else { return }
                    let vc = EditTrackerViewController(viewModel: tracker)
                    let navigation = UINavigationController(rootViewController: vc)
                    vc.title = NSLocalizedString("habit_editing_title", comment: "Редактирование привычки")
                    AnalyticService.send(event: .click(screen: .main, item: .edit))
                    self?.present(navigation, animated: true)

                },
                UIAction(title: NSLocalizedString("context_menu_trackers_delete", comment: "Удалить"), attributes: .destructive) { [weak self] _ in
                    let alert = UIAlertController(
                        title: NSLocalizedString("delete_tracker_confirmation_title", comment: "Этот трекер точно не нужен?"),
                        message: nil,
                        preferredStyle: .actionSheet
                    )
                    alert.addAction(UIAlertAction(title: NSLocalizedString("delete_trackers_confirmation_delete", comment: "Удалить"), style: .destructive) { [weak self] _ in
                        self?.viewModel.removeTracker(at: indexPath)
                    })
                    alert.addAction(UIAlertAction(title: NSLocalizedString("delete_trackers_confirmation_cancel", comment: "Отмена"), style: .cancel))
                    AnalyticService.send(event: .click(screen: .main, item: .delete))
                    self?.present(alert, animated: true)
                }
            ])
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = getCellWidth(collectionView: collectionView)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    private func getCellWidth(collectionView: UICollectionView) -> CGFloat {
        let paddingWidth: CGFloat = ViewConstants.sidesIndent * ViewConstants.columnsCount + ViewConstants.columnsCount * ViewConstants.interitemSpacing / 2
        let availableWidth = collectionView.frame.width - paddingWidth
        return availableWidth / CGFloat(ViewConstants.columnsCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ViewConstants.interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ViewConstants.sidesIndent, bottom: 0, right: ViewConstants.sidesIndent)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath
        ) as? TrackerCategoryHeaderView else {
            return UICollectionReusableView()
        }
        
        if let categoryName = viewModel.sectionNameAt(indexPath.section) {
            headerView.configure(with: categoryName)
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = TrackerCategoryHeaderView()
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
          withHorizontalFittingPriority: .required,
          verticalFittingPriority: .fittingSizeLevel
        )
    }
}


// MARK: - Configure UI extension

extension TrackersViewController {
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupView() {
        view.addSubviews(collectionView, emptyTrackersLogo, searchBar, filterButton)
    }
    
    private func setupNavigationBar() {
        setupNavigationLeftButton()
        setupNavigationTitle()
        setupNavigationRightButton()
        setupFilterButtonConstraints()
    }
    
    private func setupNavigationRightButton() {
        dateButton
            .addTarget(
                self,
                action: #selector(datePickerValueChanged(_:)),
                for: .valueChanged
            )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateButton)
    }
    
    private func setupNavigationLeftButton() {
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    private func setupNavigationTitle() {
        navigationItem.title = NSLocalizedString("trackers", comment: "Трекеры")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .ypBlack
    }
    
    private func setupSearchBar() {
        setupSearchBarConstraints()
    }
    
    private func setupCollectionView() {
        configureCollectionViewDelegates()
        setupCollectionViewConstraints()
        collectionView.contentOffset.y = -100
    }
    
    private func setupEmptyTrackersLogo() {
        setupEmptyTrackersLogoConstraints()
        updateEmptyLogoVisibility()
    }
    
    private func configureCollectionViewDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView
            .register(TrackerCard.self,
                forCellWithReuseIdentifier: "trackerCell"
            )
        collectionView
            .register(
                TrackerCategoryHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header"
            )
    }
    
    private func setupSearchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidesIndent),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidesIndent),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupEmptyTrackersLogoConstraints() {
        NSLayoutConstraint.activate([
            emptyTrackersLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyTrackersLogo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyTrackersLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidesIndent),
            emptyTrackersLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidesIndent),
        ])
    }
    
    private func setupFilterButtonConstraints() {
        NSLayoutConstraint.activate([
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor
                .constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - UISearchTextFieldDelegate

extension TrackersViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


