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
        let categoryRequest = TrackerCategoryEntity.fetchRequest()
        categoryRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryEntity.categoryId),
            category.id as NSUUID
        )
        categoryRequest.fetchLimit = 1
        
        guard let categoryEntity = try context.fetch(categoryRequest).first else {
            print("Category not found: \(category)")
            return
        }
        
        trackerEntity.trackerId = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.color = tracker.color.rawValue
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = tracker.schedule
            .map { $0.rawValue }
            .joined(separator: ",")
        trackerEntity.category = categoryEntity
        try context.save()
    }
    
}

