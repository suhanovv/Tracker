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

    // MARK: - Properties
    
    private var currentDate: Date = Constants.defaultDate
    private var currentSearchText: String?
    private var trackerDataProvider: TrackerDataProviderProtocol
    
    init(trackerDataProvider: TrackerDataProviderProtocol, currentDate: Date, currentSearchText: String? = nil) {
        self.currentDate = currentDate
        self.currentSearchText = currentSearchText
        self.trackerDataProvider = trackerDataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI elements
    
    private lazy var dateButton: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .ypBlack
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(
            self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var emptyTrackersLogo: EmptyCollectionLogoView = {
        let emptyView = EmptyCollectionLogoView(
            labelText: "Что будем отслеживать?",
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
        return collectionView
    }()
    
    private lazy var searchBar: UISearchTextField = {
        let view = UISearchTextField()
        view.placeholder = "Поиск"
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .ypInputGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addTarget(self, action: #selector(searchBarTextDidChange), for: .editingChanged)
        view.delegate = self

        return view
    }()
    
    // MARK: - Handlers
    
    @objc private func addButtonTapped() {
        let createTrackerVC = CreateTrackerViewController()
        
        let navigation = UINavigationController(rootViewController: createTrackerVC)
        
        present(navigation, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = Calendar.current.startOfDay(for: sender.date)
        filterDidChange()
    }
    
    @objc func searchBarTextDidChange(_ sender: UISearchTextField) {
        if let text = sender.text, !text.isEmpty {
            currentSearchText = text
        } else {
            currentSearchText = nil
        }
        filterDidChange()
    }
    
    private func filterDidChange() {
        if let currentSearchText {
            trackerDataProvider.updateFilter(
                .init(dayOfWeek: DayOfWeek.dayOfWeekFromDate(currentDate), name: currentSearchText)
            )
        } else {
            trackerDataProvider.updateFilter(
                .init(dayOfWeek: DayOfWeek.dayOfWeekFromDate(currentDate))
            )
        }
        collectionView.reloadData()
        updateCategories()
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupView()
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        setupEmptyTrackersLogo()
    }

    private func updateCategories() {
        if collectionView.numberOfSections == 0 {
            emptyTrackersLogo.show()
        } else {
            emptyTrackersLogo.hide()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerDataProvider.numberOfItemsInSection(section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerDataProvider.numberOfSections

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "trackerCell",
            for: indexPath
        ) as? TrackerCard else {
            return UICollectionViewCell()
        }

        cell.delegate = self
        
        return configureCell(cell, for: indexPath)
    }
    
    private func configureCell(_ cell: TrackerCard, for indexPath: IndexPath) -> TrackerCard {
        guard let tracker = trackerDataProvider.trackerAt(indexPath) else {
            return cell
        }
        
        let isChecked = trackerDataProvider.isExist(
            TrackerRecord(date: currentDate, trackerId: tracker.id)
        )
        
        let isActive = Date() >= currentDate
        cell.configure(tracker: tracker, isChecked: isChecked, isActive: isActive)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingWidth: CGFloat = ViewConstants.sidesIndent * ViewConstants.columnsCount + ViewConstants.columnsCount * ViewConstants.interitemSpacing / 2
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth = availableWidth / CGFloat(ViewConstants.columnsCount)
        return CGSize(width: cellWidth, height: 148)
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
        
        if let categoryName = trackerDataProvider.sectionName(at: indexPath.section) {
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
        view.backgroundColor = .white
    }
    
    private func setupView() {
        view.addSubviews(collectionView, emptyTrackersLogo, searchBar)
    }
    
    
    private func setupNavigationBar() {
        setupNavigationLeftButton()
        setupNavigationTitle()
        setupNavigationRightButton()
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
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .ypBlack
    }
    
    private func setupSearchBar() {
        setupSearchBarConstraints()
        
    }
    
    private func setupCollectionView() {
        configureCollectionViewDelegates()
        setupCollectionViewConstraints()
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
        NSLayoutConstraint.activate(
[
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidesIndent),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidesIndent),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
            
        ]
)
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
    
    private func updateEmptyLogoVisibility() {
        if trackerDataProvider.numberOfTrackers > 0 {
            emptyTrackersLogo.hide()
        } else {
            emptyTrackersLogo.show()
        }
    }
}

// MARK: - TrackerCardDelegateProtocol

extension TrackersViewController: TrackerCardDelegateProtocol {
    func didCheckTracker(_ tracker: Tracker) {
        let record = TrackerRecord(date: currentDate, trackerId: tracker.id)
        trackerDataProvider.createTrackerRecord(record)
    }

    func didUncheckTracker(_ tracker: Tracker) {
        let record = TrackerRecord(date: currentDate, trackerId: tracker.id)
        trackerDataProvider.removeTrackerRecord(record)
    }

    
}

// MARK: - UISearchTextFieldDelegate

extension TrackersViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension TrackersViewController: TrackerDataProviderDelegate {
    func didUpdate(_ update: TrackerStoreUpdate) {
        
        collectionView.performBatchUpdates {
            collectionView.insertSections(update.insertedSections)
            collectionView.deleteSections(update.deletedSections)
            collectionView.insertItems(at: Array(update.insertedIndexes))
            collectionView.deleteItems(at: Array(update.deletedIndexes))
            collectionView.reloadItems(at: Array(update.updatedIndexes))

        }
        updateCategories()
    }
}
