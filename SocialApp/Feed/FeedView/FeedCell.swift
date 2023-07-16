//
//  FeedCell.swift
//  SocialApp
//
//  Created by Олеся on 19.06.2023.
//

import UIKit


final class FeedCell: UITableViewCell {

    private var viewModel: FeedCellViewModel?

    private lazy var contentHeaderCellView: UIView = {
        let image = UIView()
        image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onHeaderTapped))
        image.addGestureRecognizer(tapGesture)
        return image
    }()
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        let tapToImage = UITapGestureRecognizer(target: self, action: #selector(onPostImageTapped))
        image.addGestureRecognizer(tapToImage)

        return image
    }()

    private lazy var authorPhoto: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = false
        image.cornerRadius(cornerRadius: Constants.inset16)
        image.clipsToBounds = true
        return image
    }()

    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.textRegular
        label.numberOfLines = 1
        return label
    }()

    private let professionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let tapToImage = UITapGestureRecognizer(target: self, action: #selector(onPostImageTapped))
        label.addGestureRecognizer(tapToImage)
        return label
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private lazy var likesIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: IconsName.likes.nameIcon)?.imageWithColor(color: AppColors.darkGray)
        return image
    }()

    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var commentsIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: IconsName.comments.nameIcon)?.imageWithColor(color: AppColors.darkGray)
        return image
    }()

    lazy var dotsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onDotsTapped))
        image.addGestureRecognizer(gesture)
        return image
    }()

    private lazy var bookmarkIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.image = UIImage(systemName: IconsName.bookmark.nameIcon)
        let tap = UITapGestureRecognizer(target: self, action: #selector(bookmarkTapped))
        image.addGestureRecognizer(tap)
        return image
    }()

    private var commonConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        [contentHeaderCellView, authorPhoto,authorNameLabel, professionLabel, image, descriptionLabel, commentsLabel, likesLabel,   likesIcon, commentsIcon, dotsImage, bookmarkIcon].forEach {$0.forAutolayout()}
        [contentHeaderCellView, image, descriptionLabel, commentsLabel, likesLabel, authorNameLabel, professionLabel, authorPhoto, likesIcon, commentsIcon, dotsImage, bookmarkIcon].forEach {contentView.addSubview($0)}

        commonConstraints.append(
            contentsOf: [
                contentHeaderCellView.pinTop(to: contentView.topAnchor),
                contentHeaderCellView.pinLeading(to: contentView.leadingAnchor),
                contentHeaderCellView.pinTrailing(to: contentView.trailingAnchor),
                contentHeaderCellView.pinBottom(to: descriptionLabel.topAnchor),

                authorPhoto.pinHeight(equalTo: Constants.inset56),
                authorPhoto.pinWidth(equalTo: Constants.inset56),
                authorPhoto.pinTop(to: contentView.topAnchor,inset: Constants.inset16),
                authorPhoto.pinLeading(to: contentView.leadingAnchor, inset:  Constants.inset16),
                authorPhoto.pinBottom(to: descriptionLabel.topAnchor, inset: Constants.inset16),

                authorNameLabel.pinTop(to: contentView.topAnchor, inset: Constants.inset16),
                authorNameLabel.pinHeight(equalTo: Constants.inset56 / 2),
                authorNameLabel.pinLeading(to: authorPhoto.trailingAnchor, inset: Constants.inset16),
                authorNameLabel.pinTrailing(to: contentView.trailingAnchor),
                authorNameLabel.pinBottom(to: professionLabel.topAnchor),

                professionLabel.pinTop(to: authorNameLabel.bottomAnchor),
                professionLabel.pinLeading(to: authorNameLabel.leadingAnchor),
                professionLabel.pinHeight(equalTo: Constants.inset56 / 2),
                professionLabel.pinTrailing(to: dotsImage.leadingAnchor, inset: Constants.inset16),
                professionLabel.pinBottom(to: authorPhoto.bottomAnchor),

                dotsImage.pinTop(to:contentView.topAnchor,inset: Constants.inset16),
                dotsImage.pinBottom(to: authorPhoto.bottomAnchor),
                dotsImage.pinWidth(equalTo: 20),
                dotsImage.pinTrailing(to: contentView.trailingAnchor, inset: Constants.inset16),
                dotsImage.pinLeading(to: professionLabel.trailingAnchor),


                descriptionLabel.pinTop(to: authorPhoto.bottomAnchor, inset: Constants.inset16),
                descriptionLabel.pinLeading(to: contentView.leadingAnchor),
                descriptionLabel.pinTrailing(to: contentView.trailingAnchor),
                descriptionLabel.pinHeight(equalTo: 100),
                descriptionLabel.pinBottom(to: image.topAnchor),


                image.pinTop(to: descriptionLabel.bottomAnchor, inset: Constants.inset16),
                image.pinLeading(to: contentView.leadingAnchor),
                image.pinTrailing(to: contentView.trailingAnchor),
                image.pinHeight(equalTo: UIScreen.main.bounds.width),


                likesIcon.pinTop(to: image.bottomAnchor, inset: Constants.inset16),
                likesIcon.pinLeading(to: contentView.leadingAnchor, inset: Constants.inset16),
                likesIcon.pinHeight(equalTo: Constants.inset56 / 2),
                likesIcon.pinWidth(equalTo: Constants.inset56 / 2),
                likesIcon.pinBottom(to: contentView.bottomAnchor, inset: Constants.inset16),


                likesLabel.pinTop(to: image.bottomAnchor, inset: Constants.inset16),
                likesLabel.pinHeight(equalTo: Constants.inset56 / 2),
                likesLabel.pinWidth(equalTo: Constants.inset56),
                likesLabel.pinLeading(to: likesIcon.trailingAnchor, inset: Constants.inset8),
                likesLabel.pinBottom(to: contentView.bottomAnchor, inset: Constants.inset16),

                commentsIcon.pinHeight(equalTo: Constants.inset56 / 2),
                commentsIcon.pinWidth(equalTo: Constants.inset56 / 2),
                commentsIcon.pinLeading(to: likesLabel.trailingAnchor, inset: Constants.inset16),
                commentsIcon.pinBottom(to: contentView.bottomAnchor, inset: Constants.inset16),

                commentsLabel.pinHeight(equalTo: Constants.inset56 / 2),
                commentsLabel.pinWidth(equalTo: Constants.inset56),
                commentsLabel.pinLeading(to: commentsIcon.trailingAnchor, inset: Constants.inset8),
                commentsLabel.pinBottom(to: contentView.bottomAnchor, inset: Constants.inset16),


                bookmarkIcon.pinTop(to: image.bottomAnchor, inset: Constants.inset16),
                bookmarkIcon.pinHeight(equalTo: Constants.inset56 / 2),
                bookmarkIcon.pinWidth(equalTo: Constants.inset56 / 2),
                bookmarkIcon.pinTrailing(to: contentView.trailingAnchor, inset: Constants.inset16),
                bookmarkIcon.pinBottom(to: contentView.bottomAnchor, inset: Constants.inset16)
            ]
        )
        NSLayoutConstraint.activate(commonConstraints)
    }

    func configure(with viewModel: FeedCellViewModel) {
        self.viewModel = viewModel

        authorNameLabel.text = viewModel.authorNameText
        descriptionLabel.text = viewModel.postText
        likesLabel.text = viewModel.likesCountString
        commentsLabel.text = viewModel.commentsCountString
        professionLabel.text = viewModel.professionText

        contentView.backgroundColor = viewModel.backgroundColor
        contentHeaderCellView.backgroundColor = viewModel.headerViewColor
        professionLabel.textColor = viewModel.professionLabelTextColor

        image.image = viewModel.postImage
        authorPhoto.image = viewModel.avatarImage
        dotsImage.image = viewModel.dotsImage

        dotsImage.isHidden = !viewModel.isNeedToShowDotsView
    }

    @objc func onDotsTapped() {
        print("dotsTapped gesture worked")
        viewModel?.dotsImageTapped()
    }
    @objc func onPostImageTapped() {
        viewModel?.postImageTapped()
    }

    @objc private func onHeaderTapped() {
        viewModel?.headerTapped()
    }
    @objc private func bookmarkTapped() {
        print("bookmarkTapped gesture worked")
        viewModel?.bookmarkTapped()
//        TODO: - implement isSaved maybe later
    }

    func configureFavorite(favoritePost: FavoritePost) {
        guard let postImage = favoritePost.postImage else { return }
        guard let authorAvatar = favoritePost.authorAvatar else { return }
        image.image = UIImage(data: postImage)
        authorNameLabel.text = favoritePost.authorNickname
        descriptionLabel.text = favoritePost.descriptionPost
        commentsLabel.text = String(favoritePost.commentsCount)
        likesLabel.text = String(favoritePost.likesCount)
        authorPhoto.image = UIImage(data: authorAvatar)

    }
}
