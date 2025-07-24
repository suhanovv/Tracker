//
//  CategoryViewControllerFactory.swift
//  Tracker
//
//  Created by Вадим Суханов on 15.07.2025.
//

import UIKit

final class CategoryViewControllerFactory: ViewControllerFactoryProtocol {
    func make() -> UIViewController {
        let categoryViewModel = CategoriesViewModel()
        let view = CategoryViewController(viewModel: categoryViewModel)
        return view
    }
}
