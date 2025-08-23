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
    func update(_ category: TrackerCategory) throws
    func getAll() throws -> [TrackerCategory]
    func deleteCategory(byId id: UUID) throws
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
    
    func update(_ category: TrackerCategory) throws {
        let categoryEntity = try fetchCategoryEntity(for: category.id)
        categoryEntity.name = category.name
        
        try context.save()
    }
    
    func deleteCategory(byId id: UUID) throws {
        let category = try fetchCategoryEntity(for: id)
        context.delete(category)
        try context.save()
    }
    
    func removeAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerCategoryEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try context.execute(batchDeleteRequest)
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
    
    private func fetchCategoryEntity(for categoryId: UUID) throws -> TrackerCategoryEntity {
        let request = TrackerCategoryEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryEntity.categoryId),
            categoryId as NSUUID
        )
        request.fetchLimit = 1

        guard let entity = try context.fetch(request).first else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategory
        }
        return entity
    }
}
