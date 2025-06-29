//
//  NewHabbitViewPresenter.swift
//  Tracker
//
//  Created by Вадим Суханов on 27.06.2025.
//

import Foundation

// MARK: - NewHabbitViewPresenterProtocol
protocol NewHabbitViewPresenterProtocol: AnyObject {
    func trackerNameChanged(_ name: String)
    func scheduleChanged(_ schedule: [DayOfWeek])
    func categoryChanged(_ category: TrackerCategory?)
    func getSelectedCategory() -> TrackerCategory?
    func getSelectedSchedule() -> [DayOfWeek]
    func createNewTracker(completion: @escaping (() -> Void))
    
}

// MARK: - NewHabbitViewPresenter
final class NewHabbitViewPresenter: NewHabbitViewPresenterProtocol {
    
    private weak var view: NewHabbitViewControllerProtocol?
    private let categoriesRepository: TrackerCategoryRepositoryProtocol
    
    private var trackerName: String = ""
    private var schedule: [DayOfWeek] = []
    
    private var category: TrackerCategory?

    init(
        view: NewHabbitViewControllerProtocol,
        trackerCategoryRepository: TrackerCategoryRepositoryProtocol
    ) {
        self.view = view
        self.categoriesRepository = trackerCategoryRepository
        category = categoriesRepository.getAll().first
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
    
    private func validate() {
        let trackerNameValidationResult = TrackerNameValidator.validate(trackerName)
        let scheduleValidationResult = ScheduleValidator.validate(schedule)
        
        switch (trackerNameValidationResult, scheduleValidationResult) {
        case (.valid, .valid):
            view?.hideTrackerNameError()
            view?.activateCreateButton()
        case (.tooLong, _):
            view?.showTrackerNameError()
            view?.deactivateCreateButton()
        case (.empty, _):
            view?.deactivateCreateButton()
        case (_, .empty):
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
        guard let currentCategory = category else { return }
        let tracker = Tracker(name: trackerName, schedule: schedule)
        print(tracker)
        category = currentCategory.addTracker(tracker)
        if let category {
            categoriesRepository.update(category: category)
        }
        completion()
    }
}
