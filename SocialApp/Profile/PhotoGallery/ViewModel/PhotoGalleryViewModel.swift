//
//  PhotoGalleryViewModel.swift
//  SocialApp
//
//  Created by Олеся on 08.07.2023.
//

import UIKit

enum PhotoGalleryItem {
    case separator
    case header(PhotoGalleryHeaderCellViewModel)
    case photo(PhotoCollectionViewCellViewModel)
}

final class PhotoGalleryViewModel: NSObject {
    private typealias SectionItems = [[PhotoGalleryItem]]
    private var items: SectionItems = []

    var rightBarItemImage: UIImage = UIImage(systemName: IconsName.person.nameIcon) ?? UIImage()

    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 8, left: 16, bottom: 8, right: 16)
        return layout
    }

    init(photosTitles: [String]) {
        super.init()
        items = createItems(photosTitles: photosTitles)
    }

    private func createItems(photosTitles: [String]) -> SectionItems {
        guard photosTitles.count > 0 else { return [[]]}
        let albumsSectionHeaderVm = PhotoGalleryHeaderCellViewModel(
            title: "Альбомы",
            count: 1,
            isNeedToShowButton: true
        )
        let albumsSectionItemVm = PhotoCollectionViewCellViewModel(imageString: photosTitles.first ?? "")
        let photosSectionHeaderVm = PhotoGalleryHeaderCellViewModel(title: "Все фотографии", count: photosTitles.count, isNeedToShowButton: false)
        let photosSectionItemsVms = photosTitles.map { PhotoCollectionViewCellViewModel(imageString: $0) }
        let firstSection: [PhotoGalleryItem] = [
            .separator,
            .header(albumsSectionHeaderVm),
            .photo(albumsSectionItemVm),
        ]
        var secondSection: [PhotoGalleryItem] = [.separator, .header(photosSectionHeaderVm)]
        secondSection.append(contentsOf: photosSectionItemsVms.map { .photo($0)})
        return [firstSection, secondSection]
    }

    func registerCells(collectionView: UICollectionView) {
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.register(PhotoGalleryHeaderCell.self, forCellWithReuseIdentifier: PhotoGalleryHeaderCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
        }
}

extension PhotoGalleryViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        items.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard items.count > section else { return 0 }
        return items[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard items.count > indexPath.section,
              items[indexPath.section].count > indexPath.item else { return UICollectionViewCell() }
        let item = items[indexPath.section][indexPath.item]
        switch item {
        case .header(let headerVm):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryHeaderCell.identifier, for: indexPath) as? PhotoGalleryHeaderCell else { return UICollectionViewCell() }
            cell.configure(viewModel: headerVm)
            return cell
        case .photo(let photoVm):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(photo: photoVm.imageString)
            return cell
        case .separator:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.identifier, for: indexPath)
            cell.backgroundColor = AppColors.darkGray
            return cell
        }
    }
}

extension PhotoGalleryViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard items.count > indexPath.section,
              items[indexPath.section].count > indexPath.item else { return .zero }
        let item = items[indexPath.section][indexPath.item]
        switch item {
        case .header:
            return .init(width: collectionView.bounds.width - 32, height: 20)
        case .photo:
            let width = (collectionView.bounds.width - 32 - 24) / 4
            return .init(width: width, height: width)
        case .separator:
            return .init(width: collectionView.bounds.width - 32, height: 1)
        }
    }
}
