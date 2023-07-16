//
//  FirstFeedCell.swift
//  SocialApp
//
//  Created by Олеся on 21.06.2023.
//

import UIKit

final class FirstFeedCell: UITableViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        return collection
    }()

    private var profiles: [Profile] = []
    private var constaintsForCell: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        contentView.addSubview(collectionView)
        collectionView.forAutolayout()
        constaintsForCell.append(contentsOf:[
            collectionView.pinTop(to: contentView.topAnchor),
            collectionView.pinBottom(to: contentView.bottomAnchor),
            collectionView.pinLeading(to: contentView.leadingAnchor),
            collectionView.pinTrailing(to: contentView.trailingAnchor),
            collectionView.pinHeight(equalTo: 100)
        ]
        )
        NSLayoutConstraint.activate(constaintsForCell)
    }

    func configure(profiles: [Profile]) {
        self.profiles = profiles
        collectionView.reloadData()
    }
}

extension FirstFeedCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as? StoryCollectionViewCell else { return UICollectionViewCell() }
        let profile = profiles[indexPath.item]
        cell.configure(profile: profile)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
}
