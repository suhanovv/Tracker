//
//  TrackerEntity.swift
//  Tracker
//
//  Created by Вадим Суханов on 06.07.2025.
//

import Foundation

extension TrackerCategoryEntity: DomainModelProtocol {
    func toDomainModel() -> TrackerCategory? {
        guard
            let id = categoryId,
            let name = name
        else { return nil }
        
        return TrackerCategory(id: id, name: name)
    }
}

