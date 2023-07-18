//
//  PhotoCollectionViewCell.swift
//  SocialApp
//
//  Created by Олеся on 28.06.2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    private var constraintsForCell: [NSLayoutConstraint] = []
    private lazy var photoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.cornerRadius(cornerRadius: 15)
        image.clipsToBounds = true
        image.forAutolayout()
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        forAutolayout()
        contentView.addSubview(photoImage)
        constraintsForCell.append(contentsOf: [
            photoImage.pinTop(to: contentView.topAnchor),
            photoImage.pinLeading(to: contentView.leadingAnchor),
            photoImage.pinBottom(to: contentView.bottomAnchor),
            photoImage.pinTrailing(to: contentView.trailingAnchor),
        ])
        NSLayoutConstraint.activate(constraintsForCell)
    }

    func configure(photo: String) {
        photoImage.image = UIImage(named: photo)
    }
}
