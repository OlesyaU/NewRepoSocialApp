//
//  ProfileActionsViewModel.swift
//  SocialApp
//
//  Created by Олеся on 26.06.2023.
//

import Foundation

class ProfileActionViewModel {
    enum ProfileActionsType {
        case publications(count: Int)
        case subscriptions(count: Int)
        case subscribers(count: Int)

        var title: String {
            switch self {
                case .publications:
                    return "публикаций"
                case .subscriptions:
                    return "подписок"
                case .subscribers:
                    return "подписчиков"
            }
        }
    }

    var isSelected: Bool {
        didSet {
            onModelChanged?()
        }
    }
    
    var onModelSelected: (() -> Void)?
    var onModelChanged: (() -> Void)?
    let itemsColor = AppColors.black
    let chosenItemColor = AppColors.orange
    let type: ProfileActionsType

    var count: Int {
        switch type {
            case let .publications(count), let .subscribers(count), let .subscriptions(count):
                return count
        }
    }

    init(isSelected: Bool, type: ProfileActionsType, onModelSelected: @escaping () -> Void) {
        self.isSelected = isSelected
        self.type = type
        self.onModelSelected = onModelSelected
            }

    func viewDidTapped() {
        onModelSelected?()
    }
}
