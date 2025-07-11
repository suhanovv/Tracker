//
//  NewHabitViewPresenter.swift
//  Tracker
//
//  Created by Вадим Суханов on 27.06.2025.
//

import Foundation

// MARK: - NewHabitViewPresenterProtocol
protocol NewHabitViewPresenterProtocol: AnyObject {
    func trackerNameChanged(_ name: String)
    func scheduleChanged(_ schedule: [DayOfWeek])
    func categoryChanged(_ category: TrackerCategory?)
    func emojiChanged(_ emoji: String?)
    func colorChanged(_ colorName: CardColor?)
    func getSelectedCategory() -> TrackerCategory?
    func getSelectedSchedule() -> [DayOfWeek]
    func createNewTracker(completion: @escaping (() -> Void))
    
}

// MARK: - NewHabitViewPresenter
final class NewHabitViewPresenter: NewHabitViewPresenterProtocol {
    
    private weak var view: NewHabitViewControllerProtocol?

    
    private var trackerName: String = ""
    private var schedule: [DayOfWeek] = []
    
    private var category: TrackerCategory?
    
    private var emoji: String?
    private var color: CardColor?
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerStore = TrackerStore()

    init(view: NewHabitViewControllerProtocol) {
        self.view = view
        
        // TODO: убрать в 16 спринте
        makeDefaultCategory()
    }
    
    private func makeDefaultCategory() {
        if let category = try? trackerCategoryStore.getAll().first {
            self.category = category
        } else {
            let defaultCategory = TrackerCategory(name: "Дефолт категория")
            try? trackerCategoryStore.create(defaultCategory)
            self.category = defaultCategory
        }
    }
    
    func trackerNameChanged(_ name: String) {
        trackerName = name
        validate()
    }
    
    func scheduleChanged(_ schedule: [DayOfWeek]){
        self.schedule = schedule
        view?.updateSelectedScheduleButtonCaption(makeScheduleCaption(schedule))
        validate()
    }
    
    func emojiChanged(_ emoji: String?) {
        self.emoji = emoji
        validate()
    }
    
    func colorChanged(_ colorName: CardColor?) {
        self.color = colorName
        validate()
    }
    
    private func validate() {
        let trackerNameValidationResult = TrackerNameValidator.validate(trackerName)
        let scheduleValidationResult = ScheduleValidator.validate(schedule)
        let emojiValidationResult = EmojiValidator.validate(emoji)
        let colorValidationResult = ColorValidator.validate(color)
        
        
        switch (
            trackerNameValidationResult, scheduleValidationResult,
            emojiValidationResult, colorValidationResult) {
        case (.valid, .valid, .valid, .valid):
            view?.hideTrackerNameError()
            view?.activateCreateButton()
        case (.tooLong, _, _, _):
            view?.showTrackerNameError()
            view?.deactivateCreateButton()
        default:
            view?.deactivateCreateButton()
        }
        
    }
    
    private func makeScheduleCaption(_ schedule: [DayOfWeek]) -> String {
        if schedule.count == DayOfWeek.allCases.count {
            return "Каждый день"
        } else {
            return schedule.sorted {
                let days = DayOfWeek.allCases
                guard
                    let firstIndex = days.firstIndex(of: $0),
                    let secondIndex = days.firstIndex(of: $1)
                else { return false }
                return firstIndex < secondIndex
            }.map { $0.shortName() }.joined(
                separator: ", "
            )
        }
    }
    
    func categoryChanged(_ category: TrackerCategory?) {
        self.category = category
    }
    
    func getSelectedCategory() -> TrackerCategory? {
        return category
    }
    
    func getSelectedSchedule() -> [DayOfWeek] {
        return schedule
    }
    
    func createNewTracker(completion: @escaping (() -> Void)) {
        guard
            let currentCategory = category,
            let color,
            let emoji
        else { return }
        
        let tracker = Tracker(
            name: trackerName,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
        
        try? trackerStore.create(tracker, in: currentCategory)
        
        completion()
    }
}
