//
//  PhotoGalleryViewController.swift
//  SocialApp
//
//  Created by Олеся on 08.07.2023.
//

import UIKit

final class PhotoGalleryViewController: UIViewController {
    private let viewModel: PhotoGalleryViewModel

    private lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewModel.layout)
        return collection
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фотографии"
        label.textAlignment = .left
        return label
    }()

    init(viewModel: PhotoGalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }

    private func layout() {
        view.addSubview(collection)
        collection.forAutolayout()

        NSLayoutConstraint.activate(collection.pinEdges(to: view))
        collection.dataSource = viewModel
        collection.delegate = viewModel

        viewModel.registerCells(collectionView: collection)
        collection.collectionViewLayout = viewModel.layout
        collection.reloadData()
    }

    private func configureNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .systemOrange

        let leftBackItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .done,
            target: self,
            action: #selector(backButtonTapped)
        )
        let leftTitleItem = UIBarButtonItem(customView: titleLabel)
        let rightBarButtonItem = UIBarButtonItem(
            image: viewModel.rightBarItemImage,
            style: .plain,
            target: self,
            action: #selector(addButtonPressed)
        )
        rightBarButtonItem.tintColor = .systemOrange
        rightBarButtonItem.width = 30
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
            self.navigationItem.leftBarButtonItems = [leftBackItem, leftTitleItem]
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func addButtonPressed() {
        print("add tapped")
    }
}

