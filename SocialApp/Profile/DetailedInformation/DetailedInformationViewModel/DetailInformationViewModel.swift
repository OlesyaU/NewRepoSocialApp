//
//  DetailInformationViewModel.swift
//  SocialApp
//
//  Created by Олеся on 06.07.2023.
//

import UIKit

enum DetailedInformationViewType {
    case settings
    case information
}

final class DetailInformationViewModel {
    let profile: Profile
    let textColor = AppColors.black
    let titleFont = UIFont.textBold
    let itemsFont = UIFont.textRegular
    let tappedIconsColor = AppColors.orange
    let iconsAndTextColor = AppColors.black
    let backgroundColor = AppColors.biege
    let closeIconString = IconsName.close.nameIcon
    let arrowIconString = IconsName.leftArrow.nameIcon
    let titleHeaderView = "Профиль"
    let titlesButtonInformationState = ["Основная информация", "Контакты","Интересы", "Образование", "Карьера"]
    let titlesButtonSettingsState = ["Закладки", "Понравилось", "Файлы","Архивы", "Настройки"]
    let iconNamesSettingsState = [IconsName.star.nameIcon, IconsName.likes.nameIcon,IconsName.files.nameIcon,IconsName.archive.nameIcon,IconsName.settings.nameIcon]
    var type: DetailedInformationViewType = .information

    let headerViewModel: DetailedInformationHeaderViewModel
    weak var delegate: DetailedInformationHeaderViewModelDelegate? {
        didSet {
            headerViewModel.delegate = delegate
        }
    }
    init(
        profile: Profile,
        type: DetailedInformationViewType
    ) {
        self.profile = profile
        self.type = type
        headerViewModel = DetailedInformationHeaderViewModel(
            name: profile.name,
            surname: profile.surname,
            type: type
        )
    }
}
