//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Вадим Суханов on 12.06.2025.
//

import XCTest
import SnapshotTesting

@testable import Tracker

final class TrackerTests: XCTestCase {

    func testMainViewControllerLight() throws {
        // Arrange
        let trackerStore = TrackerStore()
        let categoryStore = TrackerCategoryStore()
        try? trackerStore.removeAll()
        try? categoryStore.removeAll()
        
        let category = TrackerCategory(name: "Тестовая категория light")
        try? categoryStore.create(category)
        
        let tracker = Tracker(
            name: "Тестовый трекер light",
            color: .cardColor1,
            emoji: "😻",
            schedule: DayOfWeek.allCases,
            category: category
        )
        
        // Act
        try? trackerStore.create(tracker)
        let vc = TrackersViewControllerFactory().make()
        
        // Assert
        vc.overrideUserInterfaceStyle = .light
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        
    }
    
    func testMainViewControllerDark() throws {
        // Arrange
        let trackerStore = TrackerStore()
        let categoryStore = TrackerCategoryStore()
        try? trackerStore.removeAll()
        try? categoryStore.removeAll()
        
        let category = TrackerCategory(name: "Тестовая категория dark")
        try? categoryStore.create(category)
        
        let tracker = Tracker(
            name: "Тестовый трекер dark",
            color: .cardColor5,
            emoji: "🎸",
            schedule: DayOfWeek.allCases,
            category: category
        )
        
        // Act
        try? trackerStore.create(tracker)
        let vc = TrackersViewControllerFactory().make()
        
        // Assert
        vc.overrideUserInterfaceStyle = .dark
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }

}
