//
//  EditCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 18.07.2025.
//

import Foundation

final class EditCategoryViewModel {
    private let store: TrackerCategoryStore
    private var category: CategoryViewModel?
    private(set) var name: String?
    private(set) var isNameErrorActive: Bool = false {
        didSet {
            isNameErrorActiveBinding?(isNameErrorActive)
        }
    }
    private(set) var isButtonActive: Bool = false {
        didSet {
            isButtonActiveBinding?(isButtonActive)
        }
    }

    var isNameErrorActiveBinding: ((Bool) -> Void)?
    var isButtonActiveBinding: ((Bool) -> Void)?
    
    convenience init() {
        let store: TrackerCategoryStore = .init()
        self.init(category: nil, store: store)
    }
    
    convenience init(category: CategoryViewModel) {
        let store: TrackerCategoryStore = .init()
        self.init(category: category, store: store)
    }
    
    init(category: CategoryViewModel?, store: TrackerCategoryStore) {
        self.store = store
        self.category = category
        if let name = category?.name {
            validateName(name)
        }
    }
    
    func saveCategory() {
        guard let name else { return }
        
        if let category{
            try? store.update(TrackerCategory(id: category.id, name: name))
        } else {
            try? store.create(TrackerCategory(name: name))
        }
    }
    
    func didChangeName(_ newName: String) {
        validateName(newName)
    }
    
    private func validateName(_ name: String) {
        let validationResult = TrackerNameValidator.validate(name)
        switch validationResult {
            case .valid:
                self.name = name
                isNameErrorActive = false
                isButtonActive = true
            case .empty:
                isNameErrorActive = false
                isButtonActive = false
            case .tooLong:
                isNameErrorActive = true
                isButtonActive = false
        }
    }
}
