//
//  ViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 12.06.2025.
//

import UIKit

// MARK: - TrackersViewController

class TrackersViewController: UIViewController {
    
    private enum ViewConstants {
        static let sidesIndent: CGFloat = 16
        static let columnsCount: CGFloat = 2
        static let interitemSpacing: CGFloat = 9
    }

    // MARK: - Properties
    
    private let trackerCategoryRepository: TrackerCategoryRepositoryProtocol = TrackerCategoryRepository.shared
    private var trackerRepositoryObserver: NSObjectProtocol?
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    private var currentSearchText: String?
    
    // MARK: - UI elements
    
    private lazy var dateButton: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .ypBlack
        datePicker.locale = Locale(identifier: Constants.localeIdentifier)
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
        currentDate = sender.date
        updateCategories()
    }
    
    @objc func searchBarTextDidChange(_ sender: UISearchTextField) {
        if let text = sender.text, !text.isEmpty {
            currentSearchText = text
        } else {
            currentSearchText = nil
        }
        categories = trackerCategoryRepository.search(by: currentDate, name: currentSearchText)
        collectionView.reloadData()
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = trackerCategoryRepository
            .search(by: currentDate, name: nil)
        setupAppearance()
        setupView()
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        setupEmptyTrackersLogo()
        
        subscribeToCategoryRepositoryUpdates()
    }
    
    private func subscribeToCategoryRepositoryUpdates() {
        trackerRepositoryObserver = NotificationCenter.default
            .addObserver(
                forName: TrackerCategoryRepository.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateCategories()
            }
    }
    
    private func updateCategories() {
        categories = trackerCategoryRepository
            .search(by: currentDate, name: currentSearchText)
        collectionView.reloadData()
        if categories.isEmpty {
            emptyTrackersLogo.show()
        } else {
            emptyTrackersLogo.hide()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.filter { !$0.trackers.isEmpty }.count
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
        let category = categories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        let checkedDays = completedTrackers.filter { $0.trackerId == tracker.id }
        let isChecked: Bool = checkedDays.first(
            where: { $0.date == currentDate
            }) != nil
        
        let isActive = Date() >= currentDate
        cell.configure(tracker: tracker, checkedDaysCount: checkedDays.count, isChecked: isChecked, isActive: isActive)
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
        #warning("Вытащить в константы")
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
        
        let category = categories[indexPath.section]
        headerView.configure(with: category.name)
        
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
        if categories.first(where: { !$0.trackers.isEmpty }) != nil {
            emptyTrackersLogo.hide()
        } else {
            emptyTrackersLogo.show()
        }
    }
}

// MARK: - TrackerCardDelegateProtocol

extension TrackersViewController: TrackerCardDelegateProtocol {
    func didCheckTracker(trackerId: UUID, completion: @escaping (Int) -> Void) {
        completedTrackers.insert(TrackerRecord(date: currentDate, trackerId: trackerId))
        completion(completedTrackers.filter { $0.trackerId == trackerId }.count)
    }

    func didUncheckTracker(trackerId: UUID, completion: @escaping (Int) -> Void) {
        completedTrackers.remove(TrackerRecord(date: currentDate, trackerId: trackerId))
        completion(completedTrackers.filter { $0.trackerId == trackerId }.count)
    }

    
}

// MARK: - UISearchTextFieldDelegate

extension TrackersViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
