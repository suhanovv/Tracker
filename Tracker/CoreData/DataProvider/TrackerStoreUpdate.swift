//
//  TrackerStoreUpdate.swift
//  Tracker
//
//  Created by Вадим Суханов on 10.07.2025.
//

import Foundation

struct TrackerStoreUpdate {
    let insertedIndexes: Set<IndexPath>
    let deletedIndexes: Set<IndexPath>
    let updatedIndexes: Set<IndexPath>
    
    let insertedSections: IndexSet
    let deletedSections: IndexSet
    let updatedSections: IndexSet
}
