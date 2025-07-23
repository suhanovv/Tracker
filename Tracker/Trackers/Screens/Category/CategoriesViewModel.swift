//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 18.07.2025.
//

import Foundation

protocol CategoriesViewModelProtocol {
    var isLogoHidden: Bool { get }
    var numberOfCategories: Int { get }
    
    var categoriesBinding: (() -> Void)? { get set }
    var logoBinding: ((Bool) -> Void)? { get set }
    
    func category(at indexPath: IndexPath) -> CategoryViewModel?
    func toggleSelectionCategory(at indexPath: IndexPath)

    func removeCategory(at indexPath: IndexPath)
}

final class CategoriesViewModel {
    private var dataProvider: TrackerCategoryDataProviderProtocol
    
    var numberOfCategories: Int {
        dataProvider.numberOfCategories
    }
    var isLogoHidden: Bool {
        dataProvider.numberOfCategories != 0
    }
    private var selectedCategoryId: UUID? = nil {
        didSet {
            categoriesBinding?()
        }
    }
    
    var categoriesBinding: (() -> Void)?
    var logoBinding: ((Bool) -> Void)?
    
    convenience init(selectedCategoryId: UUID? = nil) {
        let store = TrackerCategoryStore()
        let dataProvider = TrackerCategoryDataProvider(categoryStore: store)
        self.init(dataProvider: dataProvider, selectedCategoryId: selectedCategoryId)
    }
    
    init(dataProvider: TrackerCategoryDataProviderProtocol, selectedCategoryId: UUID? = nil) {
        self.dataProvider = dataProvider
        self.dataProvider.delegate = self
        self.selectedCategoryId = selectedCategoryId
    }
}

extension CategoriesViewModel: CategoriesViewModelProtocol {
    
    func category(at indexPath: IndexPath) -> CategoryViewModel? {
        guard let category = dataProvider.category(at: indexPath) else { return nil }
        return CategoryViewModel(id: category.id, name: category.name, isSelected: selectedCategoryId == category.id)
    }
    
    func toggleSelectionCategory(at indexPath: IndexPath) {
        guard let category = dataProvider.category(at: indexPath) else { return }
        selectedCategoryId = selectedCategoryId == category.id ? nil : category.id
    }
    
    func removeCategory(at indexPath: IndexPath) {
        guard let category = dataProvider.category(at: indexPath) else { return }
        dataProvider.deleteCategory(byId: category.id)
    }
}

extension CategoriesViewModel: TrackerCategoryDataProviderDelegate {
    func didUpdate() {
        categoriesBinding?()
        logoBinding?(isLogoHidden)
    }
}
