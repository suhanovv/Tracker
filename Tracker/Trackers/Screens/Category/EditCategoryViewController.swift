//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Вадим Суханов on 16.07.2025.
//

import UIKit

final class EditCategoryViewController: UIViewController {
    
    private var viewModel: EditCategoryViewModel
    
    lazy private var categoryNameTextField: TextFieldWithErrorView = {
       let view = TextFieldWithErrorView(placeholder: "Введите название категории")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.setText(viewModel.name)
        switch viewModel.isNameErrorActive {
            case true: view.showError("Ограничение 38 символов")
            case false: view.hideError()
        }
        return view
    }()
    
    lazy private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
        
        button.isEnabled = viewModel.isButtonActive
        button.backgroundColor = viewModel.isButtonActive ? .ypBlack : .ypGrey
        
        return button
    }()
    
    @objc private func handleSaveButtonTapped() {
        viewModel.saveCategory()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange(sender: UITextField) {
        guard let name = sender.text else { return }
        viewModel.didChangeName(name)
    }
    
    init(viewModel: EditCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.isButtonActiveBinding = { [weak self] isActive in
            if isActive {
                self?.saveButton.isEnabled = true
                self?.saveButton.backgroundColor = .ypBlack
            } else {
                self?.saveButton.isEnabled = false
                self?.saveButton.backgroundColor = .ypGrey
            }
        }
        
        viewModel.isNameErrorActiveBinding = { [weak self] isActive in
            if isActive {
                self?.categoryNameTextField.showError("Ограничение 38 символов")
            } else {
                self?.categoryNameTextField.hideError()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupView()
        setupConstraints()
        setupNavigation()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupAppearance() {
        view.backgroundColor = .ypWhite
    }
    
    private func setupNavigation() {
        navigationItem.hidesBackButton = true
    }
    
    private func setupView() {
        view.addSubviews(
            categoryNameTextField, saveButton
        )
    }
}

extension EditCategoryViewController {
    private func setupConstraints() {
        setupCategoryNameTextFieldConstraints()
        setupSaveButtonConstraints()
    }
    
    private func setupCategoryNameTextFieldConstraints() {
        let leadingTrailing: CGFloat = 16
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailing),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailing),
        ])
    }
    
    private func setupSaveButtonConstraints() {
        let leadingTrailing: CGFloat = 20
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailing),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailing),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
