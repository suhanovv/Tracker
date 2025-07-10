//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим Суханов on 05.07.2025.
//

import CoreData
import UIKit


protocol TrackerRecordStoreProtocol {
    func create(_ record: TrackerRecord) throws
    func remove(_ record: TrackerRecord) throws
    func isExist(_ record: TrackerRecord) -> Bool
}

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context: ManagedContext.shared.viewContext)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(_ record: TrackerRecord) throws {

        let recordEntity = TrackerRecordEntity(context: context)
        recordEntity.date = record.date
        
        let trackerRequest = TrackerEntity.fetchRequest()
        trackerRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerEntity.trackerId),
            record.trackerId as NSUUID
        )

        trackerRequest.fetchLimit = 1
        guard let trackerEntity = try context.fetch(trackerRequest).first else {
            print("Tracker not found: \(record.trackerId)")
            return
        }
        trackerEntity.addToRecords(recordEntity)        
        
        try context.save()
    }
    
    func remove(_ record: TrackerRecord) throws {
        let trackerRecordRequest = TrackerRecordEntity.fetchRequest()
        trackerRecordRequest.predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            #keyPath(TrackerRecordEntity.tracker.trackerId),
            record.trackerId as NSUUID,
            #keyPath(TrackerRecordEntity.date),
            record.date as NSDate
        )
        trackerRecordRequest.fetchLimit = 1
        guard let recordEntity = try context.fetch(trackerRecordRequest).first else {
            print("Record not found: \(record.date)")
            return
        }
        context.delete(recordEntity)
        try context.save()
    }
    
    func isExist(_ record: TrackerRecord) -> Bool {
        let trackerRecordRequest = TrackerRecordEntity.fetchRequest()
        trackerRecordRequest.predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            #keyPath(TrackerRecordEntity.tracker.trackerId),
            record.trackerId as NSUUID,
            #keyPath(TrackerRecordEntity.date),
            record.date as NSDate
        )
        trackerRecordRequest.resultType = .countResultType
        if let count = try? context.count(for: trackerRecordRequest) {
            return count > 0
        }
        return false
    }
}
