//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим Суханов on 05.07.2025.
//

import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingErrorInvalidTracker
}

protocol TrackerStoreProtocol {
    func create(_ tracker: Tracker) throws
    func update(_ tracker: Tracker) throws
    func remove(_ tracker: Tracker) throws
}

final class TrackerStore: TrackerStoreProtocol {
    let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context: ManagedContext.shared.viewContext)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(_ tracker: Tracker) throws {
        guard let category = tracker.category else { return }
        let trackerEntity = TrackerEntity(context: context)
        trackerEntity.trackerId = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.color = tracker.color.rawValue
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = tracker.schedule.map(\.rawValue).joined(separator: ",")

        trackerEntity.category = try fetchCategoryEntity(for: category)
        try context.save()
    }
    
    private func fetchCategoryEntity(for category: TrackerCategory) throws -> TrackerCategoryEntity {
        let request = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryEntity.categoryId),
            category.id as NSUUID
        )
        request.fetchLimit = 1

        guard let entity = try context.fetch(request).first else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategory
        }
        return entity
    }
    
    func remove(_ tracker: Tracker) throws {
        let tracker = try fetchTrackerEntity(for: tracker)
        context.delete(tracker)
        try context.save()
    }
    
    func removeAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try context.execute(batchDeleteRequest)
    }
    
    func update(_ tracker: Tracker) throws {
        guard let category = tracker.category else { return }
        let trackerEntity = try fetchTrackerEntity(for: tracker)
        trackerEntity.name = tracker.name
        trackerEntity.color = tracker.color.rawValue
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = tracker.schedule.map(\.rawValue).joined(separator: ",")
        trackerEntity.category = try fetchCategoryEntity(for: category)
        
        try context.save()
    }
    
    private func fetchTrackerEntity(for tracker: Tracker) throws -> TrackerEntity {
        let request: NSFetchRequest<TrackerEntity> = TrackerEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerEntity.trackerId),
            tracker.id as NSUUID
        )
        request.fetchLimit = 1
    
        guard let tracker = try context.fetch(request).first else {
            throw TrackerStoreError.decodingErrorInvalidTracker
        }
        
        return tracker
    }
}
