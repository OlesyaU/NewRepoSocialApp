//
//  PhotosCellModel.swift
//  SocialApp
//
//  Created by Олеся on 28.06.2023.
//

import UIKit

protocol PhotosCellViewModelDelegate: AnyObject {
    func photosCellSelected()
}

final class PhotosCellViewModel {
    weak var delegate: PhotosCellViewModelDelegate?

    let titleCell = "Фотографии"
    let photoCountString: String
    let arrowIcon = "chevron.right"
    let photoNameString: [String]

    init(profile: Profile) {
        photoCountString = profile.photosCountString
        photoNameString = profile.photos
    }

    func photosCellSelected() {
        delegate?.photosCellSelected()
    }
}

