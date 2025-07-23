//
//  OnboardingService.swift
//  Tracker
//
//  Created by Вадим Суханов on 20.07.2025.
//

import Foundation

protocol OnboardingServiceProtocol {
    func isOnboardingCompleted() -> Bool
    func onboardingComplete()
}


final class OnboardingService: OnboardingServiceProtocol {
    private let key = "onboardingCompleted"
    
    func isOnboardingCompleted() -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }
    
    func onboardingComplete() {
        UserDefaults.standard.set(true, forKey: key)
    }
}
