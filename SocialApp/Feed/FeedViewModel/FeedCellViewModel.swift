//
//  FeedCellViewModel.swift
//  SocialApp
//
//  Created by Олеся on 02.07.2023.
//

import UIKit

protocol FeedCellDelegate: AnyObject {
    func dotsImageTapped(post: Post, indexPath: IndexPath, isMyPost: Bool)
    func postImageTapped(post: Post)
    func headerTapped(with postAuthor: Profile)
    func bookmarkTapped(post: Post?)
}

extension FeedCellDelegate {
    func postImageTapped(post: Post) {}
    func headerTapped(with postAuthor: Profile) {}
    func dotsImageTapped(post: Post, indexPath: IndexPath, isMyPost: Bool) {}
    func bookmarkTapped(post: Post?) {}

}

final class FeedCellViewModel {
    private let postImageString: String
    private let avatarImageString: String

    private let isSaved: Bool

    private let isMyPost: Bool
    private let isFromFeed: Bool

    private let indexPath: IndexPath

    private let post: Post

    private weak var delegate: FeedCellDelegate?

    let authorNameText: String
    let postText: String
    let likesCountString: String
    let commentsCountString: String
    let professionText: String

    let backgroundColor = AppColors.biege
    let headerViewColor = AppColors.white
    let professionLabelTextColor = AppColors.lightGray

    var postImage: UIImage? {
        UIImage(named: postImageString)
    }
    var dotsImage: UIImage? {
        isNeedToShowDotsView ? UIImage(named: IconsName.dots.nameIcon)?.imageWithColor(color: AppColors.orange) : nil
    }

    var avatarImage: UIImage? {
        UIImage(named: avatarImageString)
    }

    var likesIconImage: UIImage? {
        UIImage(systemName: IconsName.likes.nameIcon)?.imageWithColor(color: AppColors.darkGray)
    }

    var bookmarkIcon: UIImage? {
        let color = isSaved ? AppColors.orange : AppColors.darkGray
        return UIImage(systemName: IconsName.bookmark.nameIcon)?.imageWithColor(color: color)
    }

    var commentsIcon: UIImage? {
        UIImage(systemName: IconsName.comments.nameIcon)?.imageWithColor(color: AppColors.darkGray)
    }

    let isNeedToShowDotsView: Bool

    init(
        post: Post,
        indexPath: IndexPath,
        isNeedToShowDotsView: Bool,
        isFromFeed: Bool,
        delegate: FeedCellDelegate?
    )  {
        postImageString = post.image
        authorNameText = post.author.name + " " + post.author.surname
        postText = post.description
        likesCountString = String(post.likes)
        commentsCountString = String(post.comments.count)
        avatarImageString = post.author.avatar
        professionText = post.author.profession
        isSaved = post.isSaved
        isMyPost = post.author == DataBase.shared.testProfile

        self.isFromFeed = isFromFeed
        self.indexPath = indexPath
        self.isNeedToShowDotsView = isNeedToShowDotsView
        self.post = post
        self.delegate = delegate
    }

    func dotsImageTapped() {
        delegate?.dotsImageTapped(post: post, indexPath: indexPath, isMyPost: isMyPost)
    }

    func postImageTapped() {
        delegate?.postImageTapped(post: post)
    }

    func headerTapped() {
        guard isFromFeed, !isMyPost else { return }
        delegate?.headerTapped(with: post.author)
    }
    func bookmarkTapped() {
        delegate?.bookmarkTapped(post: post)
    }
}
