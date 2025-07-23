//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 22.07.2025.
//

import Foundation

protocol TrackersViewModelProtocol {
    var selectedDate: Date { get }
    var searchText: String { get}
    var numberOfSections: Int { get }
    
    var selectedDateBinding: ((Date) -> Void)? { get set }
    var numberOfSectionBinding: ((Int) -> Void)? { get set }
    var searchTextBinding: ((String) -> Void)? { get set }
    var trackersChangedBinding: ((TrackerStoreUpdate) -> Void)? { get set }
    var categoriesChangedBinding: (() -> Void)? { get set }
    
    func sectionNameAt(_ section: Int) -> String?
    
    func numberOfItemsInSection(_ section: Int) -> Int
    func trackerAt(_ indexPath: IndexPath) -> TrackerCardViewModelProtocol?
    
    func changeDate(_ date: Date)
    func changeSearchText(_ text: String)
}

final class TrackersViewModel: TrackersViewModelProtocol {
    private var dataProvider: TrackerDataProviderProtocol
    private var recordStore: TrackerRecordStoreProtocol
    
    private(set) var selectedDate: Date {
        didSet {
            selectedDateBinding?(selectedDate)
        }
    }
    
    var numberOfSections: Int {
        dataProvider.numberOfSections
    }
    
    private(set) var searchText: String {
        didSet {
            searchTextBinding?(searchText)
        }
    }
    
    var selectedDateBinding: ((Date) -> Void)?
    var searchTextBinding: ((String) -> Void)?
    var numberOfSectionBinding: ((Int) -> Void)?
    var changeFilterBinding: ((TrackerFilter) -> Void)?
    var trackersChangedBinding: ((TrackerStoreUpdate) -> Void)?
    var categoriesChangedBinding: (() -> Void)?
    
    init(dataProvider: TrackerDataProviderProtocol, recordStore: TrackerRecordStoreProtocol) {
        self.dataProvider = dataProvider
        self.recordStore = recordStore
        self.selectedDate = Constants.defaultDate
        self.searchText = ""
        self.dataProvider.updateFilter(TrackerFilter(dayOfWeek: .dayOfWeekFromDate(self.selectedDate), name: ""))
    }
    
    func sectionNameAt(_ section: Int) -> String? {
        dataProvider.sectionName(at: section)
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        dataProvider.numberOfItemsInSection(section)
    }
    
    func trackerAt(_ indexPath: IndexPath) -> TrackerCardViewModelProtocol? {
        guard let tracker = dataProvider.trackerAt(indexPath) else { return nil }
        return TrackerCardViewModel(
            tracker: tracker,
            selectedDate: selectedDate,
            recordsStore: TrackerRecordStore()
        )
    }
    
    func changeDate(_ date: Date) {
        let filter = TrackerFilter(dayOfWeek: DayOfWeek.dayOfWeekFromDate(date), name: searchText)
        dataProvider.updateFilter(filter)
        selectedDate = date
    }
    
    func changeSearchText(_ text: String) {
        let filter = TrackerFilter(dayOfWeek: DayOfWeek.dayOfWeekFromDate(selectedDate), name: text)
        dataProvider.updateFilter(filter)
        searchText = text
    }
}

extension TrackersViewModel: TrackerDataProviderDelegate {
    func didUpdate(_ update: TrackerStoreUpdate) {
        trackersChangedBinding?(update)
    }
    
    func didCategoriesChange() {
        categoriesChangedBinding?()
    }
}
