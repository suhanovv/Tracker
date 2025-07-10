//
//  NewHabbitViewControlllerFactory.swift
//  Tracker
//
//  Created by Вадим Суханов on 28.06.2025.
//

import UIKit

final class NewHabbitViewControlllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let vc = NewHabbitViewController()
        let presenter = NewHabbitViewPresenter(view: vc)
        vc.presenter = presenter
        return vc
    }
}

