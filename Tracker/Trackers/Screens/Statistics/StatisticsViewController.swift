//
//  ViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 12.06.2025.
//

import UIKit

// MARK: - StatisticsViewController
class StatisticsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var emptyStatisticsLogo: EmptyCollectionLogoView = {
        let emptyView = EmptyCollectionLogoView(
            labelText: NSLocalizedString("emptyStatisticsLogoLabelText", comment: "Анализировать пока нечего"),
            resource: .emptyStatisticsLogo
        )
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        return emptyView
    }()
    
    private var viewModel: StatisticsViewModelProtocol
    
    init(viewModel: StatisticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        updateVisibilityCollectionView()
        updateVisibilityEmptyPlaceholder()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.isEmptyPlaceholderActiveBinding = { [weak self] in
            self?.updateVisibilityEmptyPlaceholder()
            self?.updateVisibilityCollectionView()
        }
        
        viewModel.statisticsChangedBinging = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func updateVisibilityEmptyPlaceholder() {
        switch viewModel.isEmptyPlaceholderActive {
            case true: emptyStatisticsLogo.isHidden = false
            case false: emptyStatisticsLogo.isHidden = true
        }
    }
    
    private func updateVisibilityCollectionView() {
        switch viewModel.isEmptyPlaceholderActive {
            case true: collectionView.isHidden = true
            case false: collectionView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupView()
        configureTableViewDelegates()
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupView() {
        view.addSubviews(emptyStatisticsLogo, collectionView)
    }
    
    private func setupNavigationBar() {
        setupNavigationTitle()
    }

    private func setupNavigationTitle() {
        navigationItem.title = NSLocalizedString("statictics.title", comment: "Статистика")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .ypBlack
    }
    
    private func setupTableView() {
        configureTableViewDelegates()
    }
    
    private func configureTableViewDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StatisticsViewCell.self, forCellWithReuseIdentifier: "statisticCell")
    }
    
    private func setupConstraints() {
        setupCollectionViewConstraints()
        setupEmptyStatisticsLogoConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupEmptyStatisticsLogoConstraints() {
        let sidesIndent: CGFloat = 16
        
        NSLayoutConstraint.activate([
            emptyStatisticsLogo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyStatisticsLogo.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyStatisticsLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidesIndent),
            emptyStatisticsLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidesIndent),
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sideInset: CGFloat = 16
        return CGSize(width: collectionView.frame.width - sideInset * 2, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12
    }
}

// MARK: - UICollectionViewDataSource
extension StatisticsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.statisticsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "statisticCell",
            for: indexPath) as? StatisticsViewCell else {
                return UICollectionViewCell()
        }
        
        cell.viewModel = viewModel.statistic(at: indexPath.row)
        
        return cell
    }
}
