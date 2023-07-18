//
//  ProfileActionsView.swift
//  SocialApp
//
//  Created by Олеся on 26.06.2023.
//

import UIKit

final class ProfileActionView: UIView {

    private var viewModel: ProfileActionViewModel?

    private var typesStackConstraints: [NSLayoutConstraint] = []

    private enum Constants {
        static let sideInset: CGFloat = 16
        static let heightIcon: CGFloat = 56
    }

    private lazy var typeContainerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(typeTap))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.lightFont
        label.numberOfLines = 1
        label.textAlignment = TextAttribute.centerText
        return label
    }()

    private lazy var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.lightFont
        label.textColor = .gray
        label.textAlignment = TextAttribute.centerText
        label.numberOfLines = 1
        return label
    }()
    
    init(){
        super.init(frame: .zero)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: ProfileActionViewModel) {
        self.viewModel = viewModel
        setupUI()
        viewModel.onModelChanged = { [weak self] in
            self?.setupUI()
        }
    }

    private func setupConstraints() {
        addSubview(typeContainerStack)
        [countLabel, typeTitleLabel, typeContainerStack].forEach({$0.forAutolayout()})
        [countLabel,typeTitleLabel].forEach { typeContainerStack.addArrangedSubview($0)}

        typesStackConstraints.append(contentsOf:[
            typeContainerStack.pinTop(to: topAnchor, inset: Constants.sideInset),
            typeContainerStack.pinLeading(to: leadingAnchor),
            typeContainerStack.pinBottom(to: bottomAnchor, inset: Constants.sideInset),
            typeContainerStack.pinTrailing(to: trailingAnchor),

            countLabel.pinTop(to: typeContainerStack.topAnchor),
            countLabel.pinLeading(to: typeContainerStack.leadingAnchor),
            countLabel.pinTrailing(to: typeTitleLabel.trailingAnchor),

            typeTitleLabel.pinLeading(to: typeContainerStack.leadingAnchor),
            typeTitleLabel.pinTrailing(to: typeTitleLabel.trailingAnchor),
            typeTitleLabel.pinBottom(to: typeContainerStack.bottomAnchor)
        ])
        NSLayoutConstraint.activate(typesStackConstraints)
    }

    private func setupUI() {
        guard let viewModel else { return }
        typeTitleLabel.text = viewModel.type.title
        countLabel.text = String(viewModel.count)

        if viewModel.isSelected {
            [countLabel,typeTitleLabel].forEach({$0.textColor = viewModel.chosenItemColor})
        } else {
            [countLabel,typeTitleLabel].forEach({$0.textColor = viewModel.itemsColor})
        }
    }

    @objc private func typeTap() {
        viewModel?.viewDidTapped()
    }
}
