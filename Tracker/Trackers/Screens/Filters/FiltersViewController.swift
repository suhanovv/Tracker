//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 29.07.2025.
//

import UIKit

// MARK: - FiltersViewController
final class FiltersViewController: UIViewController {
    var viewModel: FiltersViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .ypWhite
        tableView.allowsMultipleSelection = false
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .ypBlack
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init(viewModel: FiltersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.filtersListBinding = {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        makeViews()
        setupAppearance()
        setupNavigation()
        setupFilterView()
    }
}

// MARK: - Constraints & Configuration FiltersViewController
extension FiltersViewController {
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupNavigation() {
        title = NSLocalizedString("filters.title", comment: "Фильтры")
        navigationItem.hidesBackButton = true
    }
    
    private func makeViews() {
        view.addSubview(tableView)
    }
    
    private func setupFilterView() {
        configureFilterViewDelegates()
        setupFilterViewConstraints()
    }
    
    private func configureFilterViewDelegates() {
        tableView.register(FilterViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupFilterViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filtersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FilterViewCell
        else {
            return UITableViewCell()
        }
        let filterViewModel = viewModel.filtersList[indexPath.row]
        
        cell.viewModel = filterViewModel
        if filterViewModel.isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectFilter(at: indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
