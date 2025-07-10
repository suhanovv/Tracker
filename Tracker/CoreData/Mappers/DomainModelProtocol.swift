//
//  FromEntityMapperProtocol.swift
//  Tracker
//
//  Created by Вадим Суханов on 06.07.2025.
//

import Foundation

protocol DomainModelProtocol {
    associatedtype ModelType
    
    func toDomainModel() -> ModelType?
}
