//
//  ProfileIconButtonType.swift
//  SocialApp
//
//  Created by Олеся on 26.06.2023.
//

import UIKit

struct ProfileIconButtonViewModel {
    let type: ProfileIconButtonType
    let action: () -> Void
    let itemsColor = AppColors.black
}

enum ProfileIconButtonType {
    case write
    case history
    case photo
}

extension ProfileIconButtonType {
    var icon: UIImage {
        switch self {
            case .write:
                return UIImage(systemName: "square.and.pencil") ?? UIImage()
            case .history:
                return UIImage(systemName: "camera") ?? UIImage()
            case .photo:
                return  UIImage(systemName: "photo") ?? UIImage()
        }
    }

    var title: String {
        switch self {
            case .write:
                return "Запись"
            case .history:
                return "История"
            case .photo:
                return "Фото"
        }
    }
}
