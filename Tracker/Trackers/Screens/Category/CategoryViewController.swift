//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 12.07.2025.
//

import UIKit

protocol CategoryViewControllerProtocol: AnyObject {
    func categoryDidSelect(_ category: CategoryViewModel, completion: @escaping () -> Void)
}

final class CategoryViewController: UIViewController {
    private enum ViewConstants {
        static let buttonSidesIndent: CGFloat = 20
        static let sidesIndext: CGFloat = 16
    }
    
    private var viewModel: CategoriesViewModelProtocol
    weak var delegate: CategoryViewControllerProtocol?

    private lazy var addCategory: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("categories.addCategoryButtonTitle", comment: "Добавить категорию"), for: .normal)
        button.setTitleColor(.  ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emptyLogo: EmptyCollectionLogoView = {
        let emptyView = EmptyCollectionLogoView(
            labelText: NSLocalizedString("categories.emptyLogo.labelText", comment: "Привычки и события можно\n объединить по смыслу"),
            resource: .emptyTrackersLogo
        )
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = viewModel.isLogoHidden
        return emptyView
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .ypWhite
        view.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: CategoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        self.viewModel.categoriesBinding = { [weak self] in
            self?.tableView.reloadData()
        }
        
        self.viewModel.logoBinding = { [weak self] isHidden in
            self?.emptyLogo.isHidden = isHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupNavigation()
        makeViews()
        setupConstraints()
        setupTableView()
        
    }
    
    @objc func handleAddCategoryButtonTapped() {
        let viewModel = EditCategoryViewModel()
        let vc = EditCategoryViewController(viewModel: viewModel)
        vc.title = NSLocalizedString("newCategory.title", comment: "Новая категория")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupNavigation() {
        title = NSLocalizedString("categories.title", comment:"Категория")
        navigationItem.hidesBackButton = true
    }
    
    private func makeViews() {
        view.addSubviews(tableView, emptyLogo, addCategory)
    }
    
    private func setupTableView() {
        configureTableViewDelegates()
    }
    
    private func configureTableViewDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: "categoryCell")
    }
    
    private func setupConstraints() {
        setupCollectionViewConstraints()
        setupAddButtonConstraints()
        setupEmptyLogoConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCategory.topAnchor, constant: -24)
        ])
    }
    
    private func setupAddButtonConstraints() {
        NSLayoutConstraint.activate([
            addCategory.heightAnchor.constraint(equalToConstant: 60),
            addCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.sidesIndext),
            addCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.sidesIndext),
            addCategory.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupEmptyLogoConstraints() {
        NSLayoutConstraint.activate([
            emptyLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyLogo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewConstants.buttonSidesIndent),
            emptyLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewConstants.buttonSidesIndent),
        ])
    }
    
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryViewCell,
            let category = viewModel.category(at: indexPath)
        else {
            return UITableViewCell()
        }
        
        cell.viewModel = category
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        UIContextMenuConfiguration(actionProvider: { actions in

            return UIMenu(children: [
                UIAction(title: NSLocalizedString("categories.contextMenu.edit", comment: "Редактировать")) { [weak self] _ in
                    guard let category = self?.viewModel.category(at: indexPath) else { return }
                    let viewModel = EditCategoryViewModel(category: category)
                    let vc = EditCategoryViewController(viewModel: viewModel)
                    vc.title = NSLocalizedString("newCategory.title", comment: "Новая категория")
                    self?.navigationController?.pushViewController(vc, animated: true)
                },
                UIAction(title: NSLocalizedString("categories.contextMenu.delete", comment: "Удалить"), attributes: .destructive) { [weak self] _ in
                    
                    let alert = UIAlertController(
                        title: NSLocalizedString("delete_category_confirmation_title", comment: "Эта категория точно не нужна?"),
                        message: nil,
                        preferredStyle: .actionSheet
                    )
                    alert.addAction(UIAlertAction(title: NSLocalizedString("delete_category_confirmation_delete", comment: "Удалить"), style: .destructive) { [weak self] _ in
                        self?.viewModel.removeCategory(at: indexPath)
                    })
                    alert.addAction(UIAlertAction(title: NSLocalizedString("delete_category_confirmation_cancel", comment: "Отмена"), style: .cancel))
                    self?.present(alert, animated: true)
                }
            ])
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = viewModel.category(at: indexPath) else { return }
        viewModel.toggleSelectionCategory(at: indexPath)
        delegate?.categoryDidSelect(category) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
}
