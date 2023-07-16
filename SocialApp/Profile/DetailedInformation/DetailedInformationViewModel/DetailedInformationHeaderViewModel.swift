//
//  DetailedInformationHeaderViewModel.swift
//  SocialApp
//
//  Created by Олеся on 07.07.2023.
//

import UIKit

protocol DetailedInformationHeaderViewModelDelegate: AnyObject {
    func pop()
}

final class DetailedInformationHeaderViewModel {
    private let type: DetailedInformationViewType

    private var iconString: String {
        switch type {
            case .information:
                return IconsName.close.nameIcon
            case .settings:
                return IconsName.leftArrow.nameIcon
        }
    }
    weak var delegate: DetailedInformationHeaderViewModelDelegate?

    let profileFullName: String
    let backgroundColor = AppColors.biege
    let titleFont = UIFont.textBold
    var backIcon: UIImage? {
        UIImage(systemName: iconString)?.imageWithColor(color: AppColors.orange)
    }

    init(
        name: String,
        surname: String,
        type: DetailedInformationViewType
    ) {
        profileFullName = name + " " + surname
        self.type = type
    }

    func backSelected() {
        delegate?.pop()
    }
}
