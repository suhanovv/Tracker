//
//  NewHabitViewControlllerFactory.swift
//  Tracker
//
//  Created by Вадим Суханов on 28.06.2025.
//

import UIKit

final class NewHabitViewControlllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let vc = NewHabitViewController()
        let presenter = NewHabitViewPresenter(view: vc)
        vc.presenter = presenter
        return vc
    }
}

