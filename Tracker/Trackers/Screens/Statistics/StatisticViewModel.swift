//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 04.08.2025.
//

import Foundation

protocol StatisticViewModelProtocol {
    var value: Int { get }
    var name: String { get }
}

final class StatisticViewModel: StatisticViewModelProtocol {
    private(set) var value: Int
    private(set) var name: String
    
    init(value: Int, name: String) {
        self.value = value
        self.name = name
    }
}
