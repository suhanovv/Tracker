//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим Суханов on 05.07.2025.
//

import CoreData
import UIKit

protocol TrackerStoreProtocol {
    func create(_ tracker: Tracker, in category: TrackerCategory) throws
}

final class TrackerStore: TrackerStoreProtocol {
    let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context: ManagedContext.shared.viewContext)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(_ tracker: Tracker, in category: TrackerCategory) throws {
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
}
