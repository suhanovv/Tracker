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
}

// MARK: - TrackerDataProviderProtocol
protocol TrackerDataProviderProtocol {
    var numberOfSections: Int { get }
    var numberOfTrackers: Int { get }
    func numberOfItemsInSection(_ section: Int) -> Int
    func sectionName(at: Int) -> String?
    func trackerAt(_ index: IndexPath) -> Tracker?
    func isExist(_ record: TrackerRecord) -> Bool
    func createTrackerRecord(_ record: TrackerRecord)
    func removeTrackerRecord(_ record: TrackerRecord)
    func updateFilter(_ filter: TrackerFilter)
}

// MARK: - TrackerDataProvider
final class TrackerDataProvider: NSObject {
    weak var delegate: TrackerDataProviderDelegate?
    
    private let trackerRecordStore: TrackerRecordStoreProtocol
    private var fetchedResultsController: NSFetchedResultsController<TrackerEntity>?
    
    private var insertedIndexes: Set<IndexPath>?
    private var deletedIndexes: Set<IndexPath>?
    private var updatedIndexes: Set<IndexPath>?
    
    private var insertedSections: IndexSet?
    private var updatedSections: IndexSet?
    private var deletedSections: IndexSet?
    
    
    init(trackerRecordStore: TrackerRecordStoreProtocol, filter: TrackerFilter) throws {
        self.trackerRecordStore = trackerRecordStore
        super.init()
        setupFetchedResultsController(filter: filter)
    }
    
    private func setupFetchedResultsController(filter: TrackerFilter) {
        let fetchRequest = TrackerEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = makeFilterPredicate(filter: filter)

        fetchedResultsController = NSFetchedResultsController(
           fetchRequest: fetchRequest,
           managedObjectContext: ManagedContext.shared.viewContext,
           sectionNameKeyPath: "category.name",
           cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    private func makeFilterPredicate(filter: TrackerFilter) -> NSPredicate {
        var predicates: [NSPredicate] = [
            NSPredicate(
                format: "%K CONTAINS[c] %@",
                #keyPath(TrackerEntity.schedule), filter.dayOfWeek.rawValue)
        ]
        if let name = filter.name {
            predicates.append(
                NSPredicate(
                    format: "%K CONTAINS[c] %@",
                    #keyPath(TrackerEntity.name), name))
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
        fetchedResultsController?.object(at: index).toDomainModel()
    }
    
    func createTrackerRecord(_ record: TrackerRecord) {
        try? trackerRecordStore.create(record)
    }
    
    func removeTrackerRecord(_ record: TrackerRecord) {
        try? trackerRecordStore.remove(record)
    }
    
    func isExist(_ record: TrackerRecord) -> Bool {
        return trackerRecordStore.isExist(record)
    }
    
    func updateFilter(_ filter: TrackerFilter) {
        fetchedResultsController?.fetchRequest.predicate = makeFilterPredicate(filter: filter)
        try? fetchedResultsController?.performFetch()
    }
}
