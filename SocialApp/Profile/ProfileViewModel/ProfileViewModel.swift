//
//  ProfileViewModel.swift
//  SocialApp
//
//  Created by Олеся on 26.06.2023.
//

import UIKit

final class ProfileViewModel {
    var profile: Profile
    let posts: [Post]
    let findMyPostsViewModel: FindMyPostsViewModel
    let photosCellViewModel: PhotosCellViewModel
    var personalDataViewModel: PersonalDataViewModel

    let leftArrowIconString = IconsName.leftArrow.nameIcon
    let titleFrienCell = "Мои записи"
    let dotsIcon = IconsName.dots.nameIcon
    let iconsColor = AppColors.orange
    let titleColor: UIColor = .black
    let backgroundCellColor: UIColor = .backgroundPrimary
    let titleFont = UIFont.textBold

    lazy var actionsViewModels: [ProfileActionViewModel] = [
        .init(
            isSelected: true,
            type: .publications(count: profile.posts.count),
            onModelSelected:  { [weak self] in
                self?.modelSelected(at: 0)
            }),
        .init(isSelected: false, type: .subscribers(count: profile.subscribersCount), onModelSelected: { [weak self] in
            self?.modelSelected(at: 1)
        }),
        .init(isSelected: false, type: .subscriptions(count: profile.subscriptionsCount), onModelSelected:  { [weak self] in
            self?.modelSelected(at: 2)
        })
    ]

    let buttonViewModels: [ProfileIconButtonViewModel] = [
        .init(type: .write, action: {
            print("write")
        }),
        .init(type: .history, action: {
            print("history")
        }),
        .init(type: .photo, action: {
            print("photo")
        })
    ]

    var onPhotosCellSelected: (() -> Void)?

    init(profile: Profile) {
        self.profile = profile
        posts = profile.posts
        photosCellViewModel = PhotosCellViewModel(profile: profile)
        findMyPostsViewModel = FindMyPostsViewModel()
        personalDataViewModel = PersonalDataViewModel(profile: profile)
        photosCellViewModel.delegate = self
    }

    private func modelSelected(at selectedIndex: Int) {
        for index in 0...actionsViewModels.count - 1 {
            actionsViewModels[index].isSelected = false
        }
        actionsViewModels[selectedIndex].isSelected = true
    }
}

extension ProfileViewModel: PhotosCellViewModelDelegate {
    func photosCellSelected() {
        onPhotosCellSelected?()
    }
}
