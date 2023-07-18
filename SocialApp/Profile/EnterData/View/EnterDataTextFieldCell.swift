//
//  EnterDataTextFieldCell.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//

import UIKit

final class EnterDataTextFieldCell: UITableViewCell {
    private lazy var enterDataView = EnterDataTextField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        enterDataView.prepareForReuse()
    }

    func configure(with viewModel: EnterDataTextFieldViewModel) {
        enterDataView.setup(with: viewModel)
    }

    private func setupConstraints() {
        enterDataView.placed(on: contentView)
        enterDataView.forAutolayout()

        let constraints: [NSLayoutConstraint] = [
            enterDataView.pinTop(to: contentView),
            enterDataView.pinLeading(to: contentView),
            enterDataView.pinTrailing(to: contentView),
            enterDataView.pinBottom(to: contentView)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
