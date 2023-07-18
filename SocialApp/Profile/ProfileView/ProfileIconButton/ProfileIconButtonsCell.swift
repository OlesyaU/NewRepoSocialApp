//
//  ProfileIconButtonsCell.swift
//  SocialApp
//
//  Created by Олеся on 26.06.2023.
//

import UIKit

class ProfileIconButtonsCell: UITableViewCell {

    private let buttonsStackView = ProfileIconButtonsStackView()
    private var cellConstraint: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModels: [ProfileIconButtonViewModel]) {
        buttonsStackView.configure(buttonViewModels: viewModels)
    }

    private func setupConstraints() {
        buttonsStackView.placed(on: contentView)
        cellConstraint.append(contentsOf: [
            buttonsStackView.pinTop(to: contentView.topAnchor),
            buttonsStackView.pinBottom(to: contentView.bottomAnchor),
            buttonsStackView.pinLeading(to: contentView.leadingAnchor),
            buttonsStackView.pinTrailing(to: contentView.trailingAnchor),
        ])
        NSLayoutConstraint.activate(cellConstraint)
    }
}
