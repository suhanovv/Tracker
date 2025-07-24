//
//  TrackerCardViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 21.07.2025.
//

import Foundation

protocol TrackerCardViewModelProtocol {
    var trackerName: String { get }
    var emoji: String { get }
    var cardColor: CardColor { get }
    var daysCountString: String { get }
    var isCompleted: Bool { get }
    var isActive: Bool { get }
    
    var dayCountStringBinding: ((String) -> Void)? { get set }
    var isCompletedBinding: ((Bool) -> Void)? { get set }
    
    func toggleComplete()
}

final class TrackerCardViewModel: TrackerCardViewModelProtocol {
    private var tracker: Tracker
    private var selectedDate: Date
    private var recordsStore: TrackerRecordStoreProtocol
    var trackerName: String { tracker.name }
    var emoji: String { tracker.emoji }
    var cardColor: CardColor { tracker.color }
    var isActive: Bool { Date() >= selectedDate }
    
    private(set) var daysCountString: String
    private(set) var isCompleted: Bool {
        didSet {
            isCompletedBinding?(isCompleted)
        }
    }
    
    var dayCountStringBinding: ((String) -> Void)?
    var isCompletedBinding: ((Bool) -> Void)?
    
    init(
        tracker: Tracker,
        selectedDate: Date,
        recordsStore: TrackerRecordStoreProtocol,
    ) {
        self.tracker = tracker
        self.selectedDate = selectedDate
        self.recordsStore = recordsStore
        self.isCompleted = self.recordsStore.isExist(
            TrackerRecord(date: selectedDate, trackerId: tracker.id)
        )
        self.daysCountString = String.pluralize(days: tracker.countChecks)
    }
    
    func toggleComplete() {
        let record = TrackerRecord(date: selectedDate, trackerId: tracker.id)
        
        if isCompleted {
            do {
                try recordsStore.remove(record)
            } catch {
                print("ERROR: Cannot remove record with error: \(error)")
                return
            }
        } else {
            do {
                try recordsStore.create(record)
            } catch {
                print("ERROR: Cannot create record with error: \(error)")
                return
            }
        }
        isCompleted.toggle()
    }
}
