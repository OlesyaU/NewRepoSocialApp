//
//  CommentViewModel.swift
//  SocialApp
//
//  Created by Олеся on 05.07.2023.
//

import UIKit
final class CommentViewModel {
    var comment: Comment
    private let commentDate: Date
    let nickColor = AppColors.orange
    let dateTextColor = AppColors.lightGray
    let commentTextColor = AppColors.gray
    let likesIconColor = AppColors.darkGray
    let answerColor = AppColors.black
    let answerText = "Ответить"
    let likesIconName = IconsName.likes.nameIcon
    let likesIconFill = IconsName.likesFill.nameIcon
    let authorName: String
    let avatarImageString: String
    let commentText: String
    let fontRegular = UIFont.textRegular
    var commentDateString: String {
        setDateFormat(date: comment.date)
    }
    private var likesCount: Int {
        comment.likedBy.count
    }
    var likesCountString: String {
        String(likesCount)
    }
    var isLiked: Bool
    var likesIcon: UIImage? {
        let name = isLiked ? likesIconFill : likesIconName
        return UIImage(systemName: name)?.imageWithColor(color: likesIconColor)
    }

    var viewModelChanged: (() -> Void)?

    init(comment: Comment) {
        self.comment = comment
        authorName = comment.author.nickname
        avatarImageString = comment.author.avatar
        commentText = comment.text
        commentDate = comment.date
        isLiked = comment.isLiked
    }

    func likeTapped() {
        var profileIndex: Int?
        var postIndex: Int?
        var commentIndex: Int?
        profileIndex = DataBase.shared.profiles.firstIndex { profile in
            let correctPostIndex = profile.posts.firstIndex { post in
                let correctCommentIndex = post.comments.firstIndex { [weak self] comment in
                    return comment == self?.comment
                }

                if let correctCommentIndex {
                    commentIndex = correctCommentIndex
                }
                return correctCommentIndex != nil
            }
            if let correctPostIndex {
                postIndex = correctPostIndex
            }
            return correctPostIndex != nil
        }
        guard let profileIndex, let postIndex, let commentIndex else { return }
        let profile = DataBase.shared.testProfile
        if DataBase.shared.profiles[profileIndex].posts[postIndex].comments[commentIndex].likedBy.contains(profile) {
            DataBase.shared.profiles[profileIndex].posts[postIndex].comments[commentIndex].likedBy.removeAll { $0 == profile }
        } else {
            DataBase.shared.profiles[profileIndex].posts[postIndex].comments[commentIndex].likedBy.append(profile)
        }
        self.comment = DataBase.shared.profiles[profileIndex].posts[postIndex].comments[commentIndex]
        isLiked = comment.likedBy.contains(profile)

        viewModelChanged?()
    }

    private func setDateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM"
        let stringDate = dateFormatter.string(from: Date())
        return stringDate
    }
}
