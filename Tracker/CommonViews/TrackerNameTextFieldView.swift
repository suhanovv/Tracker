//
//  TrackerNameTextFieldView.swift
//  Tracker
//
//  Created by Вадим Суханов on 26.06.2025.
//

import UIKit

final class TextFieldWithErrorView: UIView {
    lazy private var textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy private var textFieldWrapperView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .ypInputGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy private var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypRed
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textFieldWrapperView, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    init(placeholder: String) {
        super.init(frame: .zero)
        textField.placeholder = placeholder
        
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        textFieldWrapperView.addSubview(textField)
        addSubview(stackView)
    }
}

extension TextFieldWithErrorView {
    private func setupConstraints() {
        setupTextFieldWrapperViewConstraints()
        setupTextFieldConstraints()
        setupStackViewConstraints()
        setupErrorLabelConstraints()
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupTextFieldWrapperViewConstraints() {
        NSLayoutConstraint.activate([
            textFieldWrapperView.heightAnchor.constraint(greaterThanOrEqualToConstant: 75),
        ])
    }
    
    private func setupTextFieldConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldWrapperView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldWrapperView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textFieldWrapperView.trailingAnchor, constant: -12),
            textField.bottomAnchor.constraint(equalTo: textFieldWrapperView.bottomAnchor),
        ])
    }
    
    private func setupErrorLabelConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
}

extension TextFieldWithErrorView {
    func setDelegate(_ delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        textField.addTarget(target, action: action, for: controlEvents)
    }
    
    func showError(_ error: String?) {
        if let error {
            errorLabel.text = error
        }
        errorLabel.isHidden = false
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    func setText(_ text: String?) {
        textField.text = text
    }
}
