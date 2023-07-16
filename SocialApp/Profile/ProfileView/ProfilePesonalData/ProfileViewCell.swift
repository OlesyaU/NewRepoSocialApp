//
//  ProfileViewCell.swift
//  SocialApp
//
//  Created by Олеся on 19.06.2023.
//

import UIKit

class ProfileViewCell: UITableViewCell {
    private enum Constants {
        static let sideInset: CGFloat = 16
    }

    private lazy var personalView = PersonalDataView()

    private var cellConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: PersonalDataViewModel) {
        personalView.configure(with: viewModel)
    }
    
    func configureFriendProfile(with friendProifile: PersonalDataViewModel) {
        personalView.configureFriendProfile()
    }
    
    private func layout() {
        [personalView].forEach({$0.forAutolayout()})
        [personalView].forEach({contentView.addSubview($0)})

        cellConstraints.append(contentsOf: [
            personalView.pinTop(to: contentView.topAnchor, inset: Constants.sideInset),
            personalView.pinLeading(to: contentView.leadingAnchor, inset: Constants.sideInset),
            personalView.pinTrailing(to: contentView.trailingAnchor, inset: Constants.sideInset),
            personalView.pinHeight(equalTo: 200),
            personalView.pinBottom(to: contentView.bottomAnchor)
        ])
        NSLayoutConstraint.activate(cellConstraints)

    }
}
