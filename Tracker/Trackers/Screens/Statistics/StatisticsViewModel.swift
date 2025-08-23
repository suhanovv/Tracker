//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Вадим Суханов on 04.08.2025.
//

import Foundation

// MARK: - StatisticsViewModelProtocol
protocol StatisticsViewModelProtocol {
    var isEmptyPlaceholderActive: Bool { get }
    var statisticsCount: Int { get }
    
    var isEmptyPlaceholderActiveBinding: (() -> Void)? { get set }
    var statisticsChangedBinging: (() -> Void)? { get set }
    
    func statistic(at index: Int) -> StatisticViewModelProtocol
}

// MARK: - StatisticsViewModel
final class StatisticsViewModel: StatisticsViewModelProtocol {
    private var dataProvider: StatisticsDataProviderProtocol
    private var data: [StatisticViewModelProtocol] = [] {
        didSet {
            statisticsChangedBinging?()
        }
    }
    
    var statisticsCount: Int {
        data.count
    }
    private(set) var isEmptyPlaceholderActive: Bool = false {
        didSet {
            isEmptyPlaceholderActiveBinding?()
        }
    }
    
    var isEmptyPlaceholderActiveBinding: (() -> Void)?
    var statisticsChangedBinging: (() -> Void)?
    
    func statistic(at index: Int) -> StatisticViewModelProtocol {
        data[index]
    }
    
    init(dataProvider: StatisticsDataProviderProtocol) {
        self.dataProvider = dataProvider
        updateStatisticsData()
        updatePlaceholderState()
    }
    
    private func updateStatisticsData() {
        data = [
            StatisticViewModel(
                value: dataProvider.finishedTrackersCount,
                name: NSLocalizedString("statistics.finishedTrackersCount.format", comment: "Трекеров завершено")),
            StatisticViewModel (
                value: dataProvider.avgDailyTrackersCount,
                name: NSLocalizedString("statistics.avgDailyTrackersCount.format", comment: "Среднее количество трекеров в день")
            )
        ]
    }
    
    private func updatePlaceholderState() {
        isEmptyPlaceholderActive = dataProvider.trackersCount == 0
    }
}

// MARK: - StatisticsDataProviderDelegate
extension StatisticsViewModel: StatisticsDataProviderDelegate {
    func didDataUpdate() {
        updateStatisticsData()
        updatePlaceholderState()
    }
}
