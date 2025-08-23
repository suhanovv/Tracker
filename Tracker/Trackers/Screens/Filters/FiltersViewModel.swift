//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 18.07.2025.
//

import Foundation

// MARK: - FiltersViewModelProtocol
protocol FiltersViewModelProtocol {
    var filtersList: [FilterViewModel] { get }
    
    var filtersListBinding: (() -> Void)? { get set }
    
    func didSelectFilter(at indexPath: IndexPath)
}

// MARK: - FiltersViewModelDelegate
protocol FiltersViewModelDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackersFilter)
}

// MARK: - FiltersViewModel
final class FiltersViewModel {
    weak var delegate: FiltersViewModelDelegate?
    
    private(set) var filtersList: [FilterViewModel] = [] {
        didSet {
            filtersListBinding?()
        }
    }
    var filtersListBinding: (() -> Void)?
    
    private var selectedFilter: TrackersFilter
    
    init(currentFilter: TrackersFilter) {
        selectedFilter = currentFilter
        updateFilters()
    }
    
    private func updateFilters() {
        filtersList = TrackersFilter.allCases.map {
            FilterViewModel(filter: $0, isSelected: $0 == selectedFilter)
        }
    }
}

// MARK: - FiltersViewModelProtocol
extension FiltersViewModel: FiltersViewModelProtocol {
    
    func didSelectFilter(at indexPath: IndexPath) {
        selectedFilter = filtersList[indexPath.row].filter
        updateFilters()
        delegate?.didSelectFilter(selectedFilter)
    }
    
}
