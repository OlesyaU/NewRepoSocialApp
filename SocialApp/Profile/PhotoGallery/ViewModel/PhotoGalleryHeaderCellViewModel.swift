//
//  PhotoGalleryHeaderCellViewModel.swift
//  SocialApp
//
//  Created by Олеся on 08.07.2023.
//
import Foundation

final class PhotoGalleryHeaderCellViewModel {
    var title: String
    var count: String
    var isNeedToShowButton: Bool

    var buttonTitle: String? {
        isNeedToShowButton ? "Показать всё" : nil
    }

    init(title: String, count: Int, isNeedToShowButton: Bool) {
        self.title = title
        self.count = String(count)
        self.isNeedToShowButton = isNeedToShowButton
    }

    func showAll() {
        print("\(#function) \(#file)")
    }
}
