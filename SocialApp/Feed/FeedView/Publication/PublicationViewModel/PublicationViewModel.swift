//
//  PublicationViewModel.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//

import UIKit
final class PublicationViewModel {
    var post: Post
    let titleController = "Публикации"
    let arrowIcon = IconsName.leftArrow.nameIcon
    let dotsIconName = IconsName.dots.nameIcon
    let colorNickname = AppColors.orange
    let colorTitle = AppColors.black
    let fontTitle = UIFont.textBold
    let fontRegular = UIFont.textRegular
    let leaveCommentStringColor = AppColors.lightGray
    let iconForComment = IconsName.moreInfo.nameIcon
    let leaveCommentViewColor = AppColors.biege
    let leaveCommentIcon = IconsName.paperclip.nameIcon
    let leaveCommentString = "оставить комментарий"

    init(post: Post) {
        self.post = post
    }
}
