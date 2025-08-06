//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 20.07.2025.
//

import UIKit

protocol OnboardingPageViewControllerDelegate: AnyObject {
    func onboardingDoneDidTapButton(_ controller: OnboardingPageViewController)
}

final class OnboardingPageViewController: UIViewController {
    
    weak var delegate: OnboardingPageViewControllerDelegate?
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .onboardingBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("onboarding.ok_button.title", comment:"Вот это технологии!"), for: .normal)
        button.backgroundColor = .onboardingBlack
        button.setTitleColor(.onboardingWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOkButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    init(imageName: String, captionText: String) {
        super.init(nibName: nil, bundle: nil)
        backgroundImageView.image = UIImage(named: imageName)
        captionLabel.text = captionText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleOkButtonTapped() {
        delegate?.onboardingDoneDidTapButton(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        setupBackgroundImageView()
        setupButton()
        setupCaptionLabel()
    }
    
    private func setupBackgroundImageView() {
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCaptionLabel() {
        view.addSubview(captionLabel)
        let leadingTrailingConstant: CGFloat = 16
        
        NSLayoutConstraint.activate([
            captionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captionLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: -view.safeAreaLayoutGuide.layoutFrame.height * 0.3),
            captionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingTrailingConstant),
            captionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -leadingTrailingConstant), 
        ])
    }
    
    private func setupButton() {
        view.addSubview(button)
        let leadingTrailingConstant: CGFloat = 20
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingConstant),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailingConstant),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
