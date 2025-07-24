//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 18.07.2025.
//

import Foundation


final class CategoryViewModel: Identifiable {
    let id: UUID
    private(set) var name: String
    private(set) var isSelected: Bool = false
    
    var nameBinding: ((String) -> Void)? {
        didSet {
            nameBinding?(name)
        }
    }
    
    var isSelectedBinding: ((Bool) -> Void)? {
        didSet {
            isSelectedBinding?(isSelected)
        }
    }
    
    init(id: UUID, name: String, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}
