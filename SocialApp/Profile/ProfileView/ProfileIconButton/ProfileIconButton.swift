//
//  ProfileIconButton.swift
//  SocialApp
//
//  Created by Олеся on 26.06.2023.
//

import UIKit

final class ProfileIconButton: UIView {
    private var iconButtonConstraint: [NSLayoutConstraint] = []
    
    private enum Constants {
        static let sideInset: CGFloat = 16
        static let heightIcon: CGFloat = 44
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.image = type.icon
        image.contentMode = .scaleAspectFit
        image.tintColor = .gray
        image.contentMode = .center
        return image
    }()
    
    private lazy var iconlabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = type.title
        label.numberOfLines = 1
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        return gesture
    }()
    
    private let type: ProfileIconButtonType
    private let onTap: (() -> Void)
    
    init(viewModel: ProfileIconButtonViewModel) {
        type = viewModel.type
        onTap = viewModel.action
        super.init(frame: .zero)
        iconlabel.textColor = viewModel.itemsColor
        iconImage.tintColor = viewModel.itemsColor
        
        isUserInteractionEnabled = true
        layout()
        addGestureRecognizer(tapGesture)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTap() {
        onTap()
    }
    
    private func layout() {
        [stackView, iconlabel, iconImage].forEach { $0.forAutolayout() }
        [iconImage, iconlabel].forEach { stackView.addArrangedSubview($0) }
        addSubview(stackView)
        iconButtonConstraint.append(contentsOf: [
            iconImage.pinTop(to: stackView.topAnchor),
            iconImage.pinHeight(equalTo: Constants.heightIcon),
            iconImage.pinWidth(equalTo: Constants.heightIcon),
            iconImage.pinLeading(to: iconlabel.leadingAnchor),
            iconImage.pinTrailing(to: iconlabel.trailingAnchor),
            
            iconlabel.pinLeading(to: stackView.leadingAnchor),
            iconlabel.pinTrailing(to: stackView.trailingAnchor),
            iconlabel.pinTop(to: iconImage.bottomAnchor),
            iconlabel.pinBottom(to: stackView.bottomAnchor),
            stackView.pinWidth(equalTo: 100),
            
            stackView.pinTop(to: topAnchor),
            stackView.pinLeading(to: leadingAnchor),
            stackView.pinTrailing(to: trailingAnchor),
            stackView.pinBottom(to: bottomAnchor, inset: Constants.sideInset)
        ])
        NSLayoutConstraint.activate(iconButtonConstraint)
    }
}
