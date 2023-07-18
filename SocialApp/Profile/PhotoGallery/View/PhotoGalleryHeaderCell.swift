//
//  PhotoGalleryHeaderCell.swift
//  SocialApp
//
//  Created by Олеся on 08.07.2023.
//

import UIKit

final class PhotoGalleryHeaderCell: UICollectionViewCell {
    
    private var viewModel: PhotoGalleryHeaderCellViewModel?

    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let showAllButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: PhotoGalleryHeaderCellViewModel) {
        self.viewModel = viewModel
        setupUI()
    }

    private func setupConstraints() {
        let views = [titleLabel, countLabel, showAllButton]
        views.forEach { $0.forAutolayout() }
        views.forEach { contentView.addSubview($0) }

        let constraints = [
            titleLabel.pinCenterY(to: contentView),
            titleLabel.pinLeading(to: contentView),

            countLabel.pinCenterY(to: contentView),
            countLabel.pinLeading(to: titleLabel.trailingAnchor, inset: Constants.inset8),

            showAllButton.pinCenterY(to: contentView),
            showAllButton.pinTrailing(to: contentView)
        ]
        NSLayoutConstraint.activate(constraints)

        countLabel.textColor = AppColors.gray
        showAllButton.setTitleColor(AppColors.orange, for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllButtonTapped), for: .touchUpInside)
    }

    private func setupUI() {
        guard let viewModel else { return }
        titleLabel.text = viewModel.title
        countLabel.text = viewModel.count
        showAllButton.isHidden = !viewModel.isNeedToShowButton
        showAllButton.setTitle(viewModel.buttonTitle, for: .normal)
    }

    @objc
    private func showAllButtonTapped() {
        viewModel?.showAll()
    }
}

