//
//  TrackerCategoryRepository.swift
//  Tracker
//
//  Created by Вадим Суханов on 24.06.2025.
//

import Foundation

// MARK: - TrackerCategoryRepositoryProtocol

protocol TrackerCategoryRepositoryProtocol {
    func getAll() -> [TrackerCategory]
    func search(by date: Date, name: String?) -> [TrackerCategory]
    func create(category: TrackerCategory)
    func update(category: TrackerCategory)
}

// MARK: - TrackerCategoryRepository

final class TrackerCategoryRepository: TrackerCategoryRepositoryProtocol {
    static let didChangeNotification = Notification.Name(rawValue: "CategoryDidChange")
    static let shared = TrackerCategoryRepository()
    private var categories: [TrackerCategory] = [
        TrackerCategory(
            name: "Домашний уют",
            trackers: [
                Tracker(
                    name: "Полить дерево чтобы не завяло",
                    color: .cardColor1,
                    emoji: "🌺",
                    schedule: [.wednesday]
                ),
                Tracker(
                    name: "Полить сельдерей",
                    color: .cardColor15,
                    emoji: "🥦",
                    schedule: [.wednesday]
                ),
                Tracker(
                    name: "Покормить кота",
                    color: .cardColor5,
                    emoji: "😻",
                    schedule: [.saturday, .sunday]
                )
            ]
        ),
        TrackerCategory(name: "Радостные мелочи", trackers: [
            Tracker(
                name: "Вкусочка Day",
                color: .cardColor13,
                emoji: "🍔",
                schedule: [.friday]
            )
        ]),
        TrackerCategory(name: "Какая то категория которая не должна поместиться на экран", trackers: [
            Tracker(
                name: "Celery day",
                color: .cardColor2,
                emoji: "🥦",
                schedule: [.friday, .wednesday, .sunday]
            )
        ]),
    ]
    
    private init() {}
    
    func getAll() -> [TrackerCategory] {
        return categories
    }
    
    func create(category: TrackerCategory) {
        categories.append(category)
        NotificationCenter.default
            .post(
                name: TrackerCategoryRepository.didChangeNotification,
                object: self,
                userInfo: ["categoryId": category.id]
            )
    }

    func update(category: TrackerCategory) {
        if let index = categories.firstIndex(where: { $0.id == category.id}) {
            categories[index] = category
            NotificationCenter.default
                .post(
                    name: TrackerCategoryRepository.didChangeNotification,
                    object: self,
                    userInfo: ["categoryId": category.id]
                )
        }
    }
    
    func search(by date: Date, name: String? = nil) -> [TrackerCategory] {
        return categories.reduce(into: []) { result, category in
            let trackers = category.trackers.filter { tracker in
                let isDateOk = filter(tracker, by: date)
                var isNameOk = true
                if let name {
                    isNameOk = filter(tracker, by: name)
                }
                return isDateOk && isNameOk
            }
            
            if !trackers.isEmpty {
                result.append(TrackerCategory(id: category.id, name: category.name, trackers: trackers))
            }
        }
    }
    
    private func filter(_ tracker: Tracker, by date: Date) -> Bool {
        return tracker.schedule.contains(DayOfWeek.dayOfWeekFromDate(date))
    }
    
    private func filter(_ tracker: Tracker, by name: String) -> Bool {
        tracker.name.lowercased().starts(with: name.lowercased())
    }
}
