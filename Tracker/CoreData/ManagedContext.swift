//
//  ManagedContext.swift
//  Tracker
//
//  Created by Вадим Суханов on 05.07.2025.
//

import Foundation
import CoreData

final class ManagedContext {
    static let shared = ManagedContext()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Persistent container init error: \(error)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private init() {}
}
