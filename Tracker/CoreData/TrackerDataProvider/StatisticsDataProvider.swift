//
//  StatisticsStore.swift
//  Tracker
//
//  Created by Вадим Суханов on 05.08.2025.
//

import CoreData


protocol StatisticsDataProviderDelegate: AnyObject {
    func didDataUpdate()
}


protocol StatisticsDataProviderProtocol {
    var trackersCount: Int { get }
    var finishedTrackersCount: Int { get }
    var avgDailyTrackersCount: Int { get }
}


final class StatisticsDataProvider: StatisticsDataProviderProtocol {
    let context: NSManagedObjectContext
    weak var delegate: StatisticsDataProviderDelegate?
    private var categoryChangeObserver: NSObjectProtocol?
    
    var trackersCount: Int {
        let request = TrackerEntity.fetchRequest()
        return (try? context.count(for: request)) ?? 0
    }
    var finishedTrackersCount: Int {
        let request = TrackerRecordEntity.fetchRequest()
        return (try? context.count(for: request)) ?? 0
    }
    
    var avgDailyTrackersCount: Int {
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "TrackerRecordEntity")
        fetchRequest.resultType = .dictionaryResultType
        
        let countDescription: NSExpressionDescription = NSExpressionDescription()
        countDescription.name = "countTrackers"
        countDescription.expression = NSExpression(
            forFunction: "count:",
            arguments: [NSExpression(forKeyPath: "tracker")]
        )
        countDescription.expressionResultType = .integer32AttributeType
        
        fetchRequest.propertiesToFetch = [countDescription, "date"]
        fetchRequest.propertiesToGroupBy = ["date"]
        
        guard let result = try? context.fetch(fetchRequest) else { return 0 }
        
        var dates = 0
        var trackers = 0
        
        result.forEach { dict in
            if let countTrackers = dict["countTrackers"] as? Int {
                trackers += countTrackers
            }
            dates += 1
        }
        if dates == 0 { return 0 }
        
        return Int(Double(trackers) / Double(dates))
    }
    
    convenience init() {
        self.init(context: ManagedContext.shared.viewContext)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        categoryChangeObserver = NotificationCenter.default
            .addObserver(
                forName: .NSManagedObjectContextDidSave,
                object: ManagedContext.shared.viewContext,
                queue: .main,
                using: contextDidChange
            )
    }
    
    @objc private func contextDidChange(_ notification: Notification) {
        delegate?.didDataUpdate()
    }
}
