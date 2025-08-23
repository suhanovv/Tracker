//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 22.07.2025.
//

import Foundation

enum TrackersSearchResultType {
    case notEmpty
    case noTrackers
    case noSearchResult
}

// MARK: - TrackersViewModelProtocol
protocol TrackersViewModelProtocol {
    var trackersSearchResult: TrackersSearchResultType { get }
    var selectedDate: Date { get }
    var searchText: String { get}
    var selectedFilter: TrackersFilter { get }
    var numberOfSections: Int { get }
    var filtersViewModel: FiltersViewModelProtocol { get }
    
    var trackersSearchResultBinding: ((TrackersSearchResultType) -> Void)? { get set }
    var selectedDateBinding: ((Date) -> Void)? { get set }
    var searchTextBinding: ((String) -> Void)? { get set }
    var trackersChangedBinding: ((TrackerStoreUpdate) -> Void)? { get set }
    var categoriesChangedBinding: (() -> Void)? { get set }
    var selectedFilterBinding: (() -> Void)? { get set }
    
    func sectionNameAt(_ section: Int) -> String?
    func numberOfItemsInSection(_ section: Int) -> Int
    func trackerViewModelAt(_ indexPath: IndexPath) -> TrackerCardViewModelProtocol?
    func editTrackerViewModelAt(_ indexPath: IndexPath) -> EditTrackerViewModelProtocol?
    func removeTracker(at indexPath: IndexPath)
    
    func changeDate(_ date: Date)
    func changeSearchText(_ text: String)
    func changeSelectedFilter(_ filter: TrackersFilter)
}

// MARK: - TrackersViewModel
final class TrackersViewModel: TrackersViewModelProtocol {
    var filtersViewModel: FiltersViewModelProtocol {
        let viewModel = FiltersViewModel(currentFilter: selectedFilter)
        viewModel.delegate = self
        return viewModel
    }
    private var dataProvider: TrackerDataProviderProtocol
    private var recordStore: TrackerRecordStoreProtocol
    private var categoryStore: TrackerCategoryStoreProtocol
    
    private(set) var trackersSearchResult: TrackersSearchResultType {
        didSet {
            trackersSearchResultBinding?(trackersSearchResult)
        }
    }
    private(set) var selectedFilter: TrackersFilter {
        didSet {
            selectedFilterBinding?()
        }
    }
    private(set) var selectedDate: Date {
        didSet {
            selectedDateBinding?(selectedDate)
        }
    }
    private(set) var searchText: String {
        didSet {
            searchTextBinding?(searchText)
        }
    }
    
    var numberOfSections: Int {
        dataProvider.numberOfSections
    }
    
    var trackersSearchResultBinding: ((TrackersSearchResultType) -> Void)?
    var selectedDateBinding: ((Date) -> Void)?
    var searchTextBinding: ((String) -> Void)?
    var selectedFilterBinding: (() -> Void)?
    var trackersChangedBinding: ((TrackerStoreUpdate) -> Void)?
    var categoriesChangedBinding: (() -> Void)?
    
    init(
        dataProvider: TrackerDataProviderProtocol,
        recordStore: TrackerRecordStoreProtocol,
        categoryStore: TrackerCategoryStoreProtocol
    ) {
        self.dataProvider = dataProvider
        self.recordStore = recordStore
        self.categoryStore = categoryStore
        self.selectedDate = Constants.defaultDate
        self.selectedFilter = TrackersFilter.all
        self.searchText = ""
        self.trackersSearchResult = .notEmpty
        self.dataProvider.updateFilter(TrackerFilterRequest(date: self.selectedDate, name: ""))
    }
    
    func sectionNameAt(_ section: Int) -> String? {
        dataProvider.sectionName(at: section)
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        dataProvider.numberOfItemsInSection(section)
    }
    
    func trackerViewModelAt(_ indexPath: IndexPath) -> TrackerCardViewModelProtocol? {
        guard let tracker = dataProvider.trackerAt(indexPath) else { return nil }
        return TrackerCardViewModel(tracker: tracker, selectedDate: selectedDate, recordsStore: self.recordStore)
    }
    
    func editTrackerViewModelAt(_ indexPath: IndexPath) -> EditTrackerViewModelProtocol? {
        guard let tracker = dataProvider.trackerAt(indexPath) else { return nil }
        let viewModel = EditTrackerViewModel(
            trackerStore: dataProvider.trackerStore,
            categoryStore: categoryStore,
            tracker: tracker
        )
        return viewModel
    }
    
    func removeTracker(at indexPath: IndexPath) {
        dataProvider.removeTracker(at: indexPath)
        updateEmptyPlaceholderType()
    }
    
    func changeDate(_ date: Date) {
        selectedDate = date
        if selectedFilter == .today {
            selectedFilter = .all
        }
        dataProvider.updateFilter(makeFilterRequest())
        updateEmptyPlaceholderType()
    }
    
    func changeSearchText(_ text: String) {
        searchText = text
        dataProvider.updateFilter(makeFilterRequest())
        updateEmptyPlaceholderType()
    }
    
    func changeSelectedFilter(_ filter: TrackersFilter) {
        selectedFilter = filter
        dataProvider.updateFilter(makeFilterRequest())
        updateEmptyPlaceholderType()
    }
    
    private func makeFilterRequest() -> TrackerFilterRequest {
        switch selectedFilter {
            case .today:
                selectedDate = Calendar.current.startOfDay(for: Date())
                return TrackerFilterRequest(
                    date: selectedDate,
                    name: searchText
                )
            case .completed, .uncompleted:
                return TrackerFilterRequest(
                    date: selectedDate,
                    name: searchText,
                    isCompleted: TrackersFilter.completed == selectedFilter
                )
            case .all :
                return TrackerFilterRequest(
                    date: selectedDate,
                    name: searchText
                )
        }
    }
    
    private func updateEmptyPlaceholderType() {
        if dataProvider.numberOfTrackers > 0 {
            trackersSearchResult = .notEmpty
            return
        }
        
        let isNoSearchResultFilter = [TrackersFilter.completed, TrackersFilter.uncompleted].contains(selectedFilter)
        
        if (!searchText.isEmpty || isNoSearchResultFilter) {
            trackersSearchResult = .noSearchResult
        } else {
            trackersSearchResult = .noTrackers
        }
    }
}

// MARK: - TrackerDataProviderDelegate
extension TrackersViewModel: TrackerDataProviderDelegate {
    func didUpdate(_ update: TrackerStoreUpdate) {
        trackersChangedBinding?(update)
        updateEmptyPlaceholderType()
    }
    
    func didCategoriesChange() {
        categoriesChangedBinding?()
    }
}

// MARK: - FiltersViewModelDelegate
extension TrackersViewModel: FiltersViewModelDelegate {
    func didSelectFilter(_ filter: TrackersFilter) {
        changeSelectedFilter(filter)
    }
}
