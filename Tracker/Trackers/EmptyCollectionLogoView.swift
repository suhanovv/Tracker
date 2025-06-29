//
//  File.swift
//  Tracker
//
//  Created by Вадим Суханов on 18.06.2025.
//

import UIKit

final class EmptyCollectionLogoView: UIView {
    
    lazy private var trackerLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy private var trackerLogoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(labelText: String, resource: ImageResource) {
        super.init(frame: .zero)
        trackerLogoLabel.text = labelText
        trackerLogo.image = UIImage(resource: resource)
        addSubviews(trackerLogo, trackerLogoLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        let leadingTrailing: CGFloat = 24
        NSLayoutConstraint.activate([
            trackerLogo.widthAnchor.constraint(equalToConstant: 80),
            trackerLogo.heightAnchor.constraint(equalTo: trackerLogo.widthAnchor, multiplier: 1),
            trackerLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            trackerLogo.topAnchor.constraint(equalTo: topAnchor),
        
            trackerLogoLabel.topAnchor.constraint(equalTo: trackerLogo.bottomAnchor, constant: 8),
            trackerLogoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrailing),
            trackerLogoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingTrailing),
            trackerLogoLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
}
