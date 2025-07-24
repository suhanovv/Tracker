//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 20.07.2025.
//

import UIKit


// MARK: - OnboardingViewController

final class OnboardingViewController: UIPageViewController {
    // MARK: - variables
    private lazy var pages: [UIViewController] = [
        OnboardingPageViewController(imageName: "OnboardingBlue", captionText: "Отслеживайте только то, что хотите"),
        OnboardingPageViewController(imageName: "OnboardingRed", captionText: "Даже если это не литры воды и йога")
    ]
    private let onboardingService: OnboardingServiceProtocol
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGrey
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    // MARK: - LifeCycle
    init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil,
        onboardingService: OnboardingServiceProtocol
    ) {
        self.onboardingService = onboardingService
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        setupPageControl()
        setupDelegates()
    }
    
    // MARK: - Handlers
    
    @objc private func handlePageControl( sender: UIPageControl) {
        guard
            let currentVC = self.viewControllers?.first,
            let currentVCIndex = pages.firstIndex(of: currentVC)
        else { return }
        
        let newIndex = sender.currentPage
        let vc = pages[newIndex]
        setViewControllers( [vc], direction: currentVCIndex > newIndex ? .reverse : .forward, animated: true)
    }
    
    private func setupDelegates() {
        pages.forEach { ($0 as? OnboardingPageViewController)?.delegate = self }
    }
    
    private func setupPageControl() {
        
        view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(handlePageControl), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentVC = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentVC) {
                pageControl.currentPage = currentIndex
            }
    }
}

// MARK: - OnboardingPageViewControllerDelegate

extension OnboardingViewController: OnboardingPageViewControllerDelegate {
    func onboardingDoneDidTapButton(_ controller: OnboardingPageViewController) {
        onboardingService.onboardingComplete()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            assertionFailure("Unable to get UIWindow")
            return
        }
        
        let mainVC = TabBarController()
        window.rootViewController = mainVC
        
        UIView
            .transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil)
    }
}
