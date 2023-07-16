//
//  CommentView.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//

import UIKit

final class CommentView: UIView {

    private var viewModel: CommentViewModel?
    private var cellConstraints: [NSLayoutConstraint] = []
    private enum Constants {
        static let sideInset: CGFloat = 8
        static let heightAvatar: CGFloat = 56
        static let likeIconSide: CGFloat = 24
    }

    private lazy var authorPhoto: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = false
        image.cornerRadius(cornerRadius: Constants.heightAvatar / 2)
        image.clipsToBounds = true
        return image
    }()
    private let authorNickLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        //        let tapToImage = UITapGestureRecognizer(target: self, action: #selector(openCurrentPost))
        //        label.addGestureRecognizer(tapToImage)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let likesCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var likesIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()

    private let answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        [authorPhoto,  authorNickLabel, commentLabel, dateLabel, likesCountLabel, likesIcon, answerLabel].forEach {$0.forAutolayout()}
        [authorPhoto,  authorNickLabel, commentLabel, dateLabel, likesCountLabel, likesIcon, answerLabel].forEach {addSubview($0)}
        cellConstraints.append(contentsOf: [
            authorPhoto.pinHeight(equalTo: Constants.heightAvatar),
            authorPhoto.pinWidth(equalTo: Constants.heightAvatar),
            authorPhoto.pinTop(to: topAnchor,inset: Constants.sideInset),
            authorPhoto.pinLeading(to:leadingAnchor, inset:  Constants.sideInset),

            authorNickLabel.pinTop(to: topAnchor, inset: Constants.sideInset),
            authorNickLabel.pinLeading(to: authorPhoto.trailingAnchor, inset: Constants.sideInset),

            likesCountLabel.pinTop(to: self, inset: Constants.sideInset),
            likesCountLabel.pinTrailing(to: self, inset: Constants.sideInset),

            likesIcon.pinTop(to: topAnchor, inset: Constants.sideInset),
            likesIcon.pinTrailing(to: likesCountLabel.leadingAnchor, inset: 4),
            likesIcon.pinHeight(equalTo: Constants.likeIconSide),
            likesIcon.pinWidth(equalTo: Constants.likeIconSide),

            commentLabel.pinTop(to: authorNickLabel.bottomAnchor),
            commentLabel.pinLeading(to: authorNickLabel.leadingAnchor),
            commentLabel.pinTrailing(to: likesIcon.leadingAnchor, inset: Constants.sideInset),

            dateLabel.pinTopGreaterThanOrEqual(to: commentLabel.bottomAnchor, inset: Constants.sideInset),
            dateLabel.pinTopGreaterThanOrEqual(to: authorPhoto.bottomAnchor, inset: Constants.sideInset),
            dateLabel.pinLeading(to: authorPhoto.leadingAnchor, inset: Constants.sideInset),
            dateLabel.pinBottom(to: self, inset: Constants.sideInset),

            answerLabel.pinTrailing(to: self, inset: Constants.sideInset),
            answerLabel.pinBottom(to: self, inset: Constants.sideInset),
        ])
        NSLayoutConstraint.activate(cellConstraints)
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
    
        likesIcon.addGestureRecognizer(iconTap)
    }

    func configureCell(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        setupUI()
        viewModel.viewModelChanged = { [weak self] in
            self?.updateUI()
        }
    }

    private func setupUI() {
        guard let viewModel else { return }
        authorNickLabel.text = viewModel.authorName
        authorNickLabel.textColor = viewModel.nickColor
        commentLabel.text = viewModel.commentText
        commentLabel.font = viewModel.fontRegular
        commentLabel.textColor = viewModel.commentTextColor
        dateLabel.text = viewModel.commentDateString
        answerLabel.text = viewModel.answerText
        authorPhoto.image = UIImage(named: viewModel.avatarImageString)
        updateUI()
    }

    private func updateUI() {
        guard let viewModel else { return }
        likesIcon.image = viewModel.likesIcon
        likesCountLabel.text = viewModel.likesCountString
    }

    @objc
    private func likeTapped() {
        viewModel?.likeTapped()
    }
}
