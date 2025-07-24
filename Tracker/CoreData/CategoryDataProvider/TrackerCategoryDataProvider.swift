//
//  CategoryDataProvider.swift
//  Tracker
//
//  Created by Вадим Суханов on 15.07.2025.
//

import CoreData


protocol TrackerCategoryDataProviderDelegate: AnyObject {
    func didUpdate()
}

protocol TrackerCategoryDataProviderProtocol {
    var numberOfCategories: Int { get }
    var delegate: TrackerCategoryDataProviderDelegate? { get set }
    
    func category(at index: IndexPath) -> TrackerCategory?
    func deleteCategory(byId id: UUID)
}

final class TrackerCategoryDataProvider: NSObject {
    weak var delegate: TrackerCategoryDataProviderDelegate?
    
    private let categoryStore: TrackerCategoryStore
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryEntity> = {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(TrackerCategoryEntity.name), ascending: true)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: categoryStore.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
    }
}

extension TrackerCategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}

extension TrackerCategoryDataProvider: TrackerCategoryDataProviderProtocol {

    var numberOfCategories: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func category(at index: IndexPath) -> TrackerCategory? {
        fetchedResultsController.object(at: index).toDomainModel()
    }
    
    func deleteCategory(byId id: UUID) {
        try? categoryStore.deleteCategory(byId: id)
    }
}
