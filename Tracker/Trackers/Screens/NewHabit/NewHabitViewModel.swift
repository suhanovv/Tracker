//
//  NewHabitViewPresenter.swift
//  Tracker
//
//  Created by Вадим Суханов on 27.06.2025.
//

import Foundation

// MARK: - NewHabitViewPresenterProtocol
protocol NewHabitViewModelProtocol: AnyObject {
    var trackerName: String { get }
    var trackerNameError: String? { get }
    var schedule: [DayOfWeek] { get }
    var scheduleCaption: String { get }
    var category: TrackerCategory? { get }
    var emoji: String? { get }
    var color: CardColor? { get }
    var isFormValid: Bool { get }
    
    var trackerNameErrorBinding: ((String?) -> Void)? { get set }
    var scheduleBinding: (([DayOfWeek]) -> Void)? { get set }
    var scheduleCaptionBinding: ((String) -> Void)? { get set }
    var categoryBinding: ((TrackerCategory?) -> Void)? { get set }
    var emojiBinding: ((String?) -> Void)? { get set }
    var colorBinding: ((CardColor?) -> Void)? { get set }
    var isFormValidBinding: ((Bool) -> Void)? { get set }
    
    func trackerNameChanged(_ name: String)
    func scheduleChanged(_ schedule: [DayOfWeek])
    func categoryChanged(_ category: TrackerCategory?)
    func emojiChanged(_ emoji: String?)
    func colorChanged(_ colorName: CardColor?)

    func createNewTracker(completion: @escaping (() -> Void))
}

// MARK: - NewHabitViewPresenter
final class NewHabitViewModel: NewHabitViewModelProtocol {
    private(set) var trackerName: String = "" {
        didSet {
            let validationResult = TrackerNameValidator.validate(trackerName)
            switch validationResult {
                case .tooLong:
                    trackerNameErrorBinding?(validationResult.resultDescription())
                default:
                    trackerNameErrorBinding?(nil)
            }
            validate()
        }
    }
    private(set) var trackerNameError: String?
    var trackerNameErrorBinding: ((String?) -> Void)?
    
    private(set) var schedule: [DayOfWeek] = [] {
        didSet {
            scheduleBinding?(schedule)
            scheduleCaptionBinding?(makeScheduleCaption(schedule))
            validate()
        }
    }
    var scheduleCaption: String {
        makeScheduleCaption(schedule)
    }
    var scheduleBinding: (([DayOfWeek]) -> Void)?
    var scheduleCaptionBinding: ((String) -> Void)?
    
    private(set) var category: TrackerCategory? {
        didSet {
            categoryBinding?(category)
            validate()
        }
    }
    var categoryBinding: ((TrackerCategory?) -> Void)?
    
    private(set) var emoji: String? {
        didSet {
            emojiBinding?(emoji)
            validate()
        }
    }
    var emojiBinding: ((String?) -> Void)?
    
    private(set) var color: CardColor? {
        didSet {
            colorBinding?(color)
            validate()
        }
    }
    var colorBinding: ((CardColor?) -> Void)?
    
    private(set) var isFormValid: Bool = false {
        didSet {
            isFormValidBinding?(isFormValid)
        }
    }
    
    var isFormValidBinding: ((Bool) -> Void)?
    
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol
    private let trackerStore: TrackerStoreProtocol

    init(trackerStore: TrackerStoreProtocol, categoryStore: TrackerCategoryStoreProtocol) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = categoryStore
    }
    
    func trackerNameChanged(_ name: String) {
        trackerName = name
    }
    
    func scheduleChanged(_ schedule: [DayOfWeek]){
        self.schedule = schedule
    }
    
    func emojiChanged(_ emoji: String?) {
        self.emoji = emoji
    }
    
    func colorChanged(_ colorName: CardColor?) {
        self.color = colorName
    }
    
    private func validate() {
        let trackerNameValidationResult = TrackerNameValidator.validate(trackerName)
        let scheduleValidationResult = ScheduleValidator.validate(schedule)
        let emojiValidationResult = EmojiValidator.validate(emoji)
        let colorValidationResult = ColorValidator.validate(color)
        
        
        switch (
            trackerNameValidationResult, scheduleValidationResult,
            emojiValidationResult, colorValidationResult) {
            case (.valid, .valid, .valid, .valid): isFormValid = true
            default: isFormValid = false
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
