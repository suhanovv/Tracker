//
//  TrackerDataProvider.swift
//  Tracker
//
//  Created by Вадим Суханов on 08.07.2025.
//

import Foundation
import CoreData


// MARK: - TrackerDataProviderDelegate
protocol TrackerDataProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
    func didCategoriesChange()
}

// MARK: - TrackerDataProviderProtocol
protocol TrackerDataProviderProtocol {
    var trackerStore: TrackerStoreProtocol { get }
    var numberOfSections: Int { get }
    var numberOfTrackers: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func sectionName(at: Int) -> String?
    func trackerAt(_ index: IndexPath) -> Tracker?
    func removeTracker(at index: IndexPath)

    func updateFilter(_ filter: TrackerFilterRequest)
}

// MARK: - TrackerDataProvider
final class TrackerDataProvider: NSObject {
    weak var delegate: TrackerDataProviderDelegate?
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerEntity>?
    private(set) var trackerStore: TrackerStoreProtocol
    private var categoryChangeObserver: NSObjectProtocol?
    
    private var insertedIndexes: Set<IndexPath>?
    private var deletedIndexes: Set<IndexPath>?
    private var updatedIndexes: Set<IndexPath>?
    
    private var insertedSections: IndexSet?
    private var updatedSections: IndexSet?
    private var deletedSections: IndexSet?
    
    
    init(store: TrackerStoreProtocol) {
        trackerStore = store
        super.init()
        setupCategoryChangeObserver()
        setupFetchedResultsController()
    }
    
    private func setupCategoryChangeObserver() {
        categoryChangeObserver = NotificationCenter.default
            .addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: ManagedContext.shared.viewContext,
                queue: .main,
                using: contextDidChange
            )
    }
    
    @objc private func contextDidChange(_ notification: Notification) {
        guard let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
                
        let categoryChanged = updatedObjects.contains { object in
            return object is TrackerCategoryEntity && object.changedValues().keys.contains("name")
        }
        if categoryChanged {
            try? fetchedResultsController?.performFetch()
            delegate?.didCategoriesChange()
        }
        
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest = TrackerEntity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.relationshipKeyPathsForPrefetching = ["category", "records.name"]
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerEntity.category.name), ascending: true),
            NSSortDescriptor(key: #keyPath(TrackerEntity.name), ascending: true)
        ]
        fetchedResultsController = NSFetchedResultsController(
           fetchRequest: fetchRequest,
           managedObjectContext: ManagedContext.shared.viewContext,
           sectionNameKeyPath: "category.name",
           cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    private func makeFilterPredicate(filter: TrackerFilterRequest) -> NSPredicate {
        var predicates: [NSPredicate] = [
            NSPredicate(
                format: "%K CONTAINS[c] %@",
                #keyPath(TrackerEntity.schedule), filter.dayOfWeek.rawValue)
        ]
        if let name = filter.name, !name.isEmpty {
            predicates.append(
                NSPredicate(
                    format: "%K CONTAINS[c] %@",
                    #keyPath(TrackerEntity.name), name))
        }
        if let isComplete = filter.isCompleted {
            let format = isComplete ? "SUBQUERY(%K, $record, $record.date == %@).@count > 0" : "SUBQUERY(%K, $record, $record.date == %@).@count == 0"
            predicates.append(
                NSPredicate(
                    format: format,
                    #keyPath(TrackerEntity.records), filter.date as NSDate))
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerDataProvider: NSFetchedResultsControllerDelegate{

    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange sectionInfo: any NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            deletedSections?.insert(sectionIndex)
        case .insert:
            insertedSections?.insert(sectionIndex)
        case .update:
            updatedSections?.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = Set<IndexPath>()
        deletedIndexes = Set<IndexPath>()
        updatedIndexes = Set<IndexPath>()
        
        insertedSections = IndexSet()
        deletedSections = IndexSet()
        updatedSections = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
           let insertedIndexes,
           let deletedIndexes,
           let updatedIndexes,
           let insertedSections,
           let deletedSections,
           let updatedSections,
           let delegate
        else { return }
        delegate.didUpdate(TrackerStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updatedIndexes,
                
                insertedSections: insertedSections,
                deletedSections: deletedSections,
                updatedSections: updatedSections
            )
        )
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        
        self.insertedSections = nil
        self.deletedSections = nil
        self.updatedSections = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath else { return }
            deletedIndexes?.insert(indexPath)
            
        case .insert:
            guard let newIndexPath else { return }
            insertedIndexes?.insert(newIndexPath)
            
        case .update:
            guard let indexPath else { return }
            updatedIndexes?.insert(indexPath)
                
        case .move:
            guard let indexPath, let newIndexPath else { return }
            deletedIndexes?.insert(indexPath)
            insertedIndexes?.insert(newIndexPath)
            
        default:
            break
        }
    }
}

// MARK: - TrackerDataProviderProtocol
extension TrackerDataProvider: TrackerDataProviderProtocol {

    func sectionName(at: Int) -> String? {
        fetchedResultsController?.sections?[at].name
    }

    var numberOfSections: Int {
        fetchedResultsController?.sections?.count ?? 0
    }
    
    var numberOfTrackers: Int {
        fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func trackerAt(_ index: IndexPath) -> Tracker? {
        return fetchedResultsController?.object(at: index).toDomainModel()
    }
    
    func updateFilter(_ filter: TrackerFilterRequest) {
        fetchedResultsController?.fetchRequest.predicate = makeFilterPredicate(filter: filter)
        try? fetchedResultsController?.performFetch()
    }
    
    func removeTracker(at index: IndexPath) {
        guard let tracker = fetchedResultsController?.object(at: index).toDomainModel() else { return }
        try? trackerStore.remove(tracker)
    }
}
