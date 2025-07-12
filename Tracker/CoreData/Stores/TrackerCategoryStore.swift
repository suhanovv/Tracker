//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим Суханов on 05.07.2025.
//

import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidCategory
}

protocol TrackerCategoryStoreProtocol {
    func create(_ category: TrackerCategory) throws
    func getAll() throws -> [TrackerCategory]
}

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context: ManagedContext.shared.viewContext)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(_ category: TrackerCategory) throws {
        let trackerCategoryEntity = TrackerCategoryEntity(context: context)
        trackerCategoryEntity.categoryId = category.id
        trackerCategoryEntity.name = category.name
        try context.save()
    }
    
    func getAll() throws -> [TrackerCategory] {
        let fetchRequest = TrackerCategoryEntity.fetchRequest()
        let entities = try context.fetch(fetchRequest)
        
        return try entities.map {
            guard let domain = $0.toDomainModel() else {
                throw TrackerCategoryStoreError.decodingErrorInvalidCategory
            }
            return domain
        }
    }
}
