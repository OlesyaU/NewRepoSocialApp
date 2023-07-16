//
//  StoryCollectionViewCell.swift
//  SocialApp
//
//  Created by Олеся on 21.06.2023.
//

import UIKit

final class StoryCollectionViewCell: UICollectionViewCell {
    private lazy var friendAvatar: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.forAutolayout()
        return image
    }()

    private var constraintsForCell: [NSLayoutConstraint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        contentView.addSubview(friendAvatar)
        let cornerRadius: CGFloat = 40
        friendAvatar.layer.cornerRadius = cornerRadius
        friendAvatar.clipsToBounds = true
        
        constraintsForCell.append(contentsOf: [
            friendAvatar.pinTop(to: contentView.topAnchor),
            friendAvatar.pinLeading(to: contentView.leadingAnchor),
            friendAvatar.pinBottom(to: contentView.bottomAnchor),
            friendAvatar.pinTrailing(to: contentView.trailingAnchor)
        ]
        )
        NSLayoutConstraint.activate(constraintsForCell)
    }

    func configure(profile: Profile) {
        friendAvatar.image = UIImage(named: profile.avatar)
    }
}
