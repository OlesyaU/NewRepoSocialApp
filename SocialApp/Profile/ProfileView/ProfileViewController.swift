//
//  ProfileViewController.swift
//  SocialApp
//
//  Created by Олеся on 19.06.2023.
//

import FloatingPanel
import UIKit

protocol ProfileViewDelegate: AnyObject {
    func showRedactProfileModule()
    func pushDetailsController(type: DetailedInformationViewType)
}

class ProfileViewController: UIViewController, FloatingPanelControllerDelegate {
    private let profileViewModel: ProfileViewModel
    private var floatingPanel: FloatingPanelController?
    private let tableDotsMenu = ProfileDotsController()
    private let tableView = UITableView()
    private let containerView = UIView()

    init(viewModel: ProfileViewModel) {
        self.profileViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        profileViewModel.personalDataViewModel.delegate = self
        setupConstraints()
        setupBindings()
        configureTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isNeedToShowNavBar = navigationController?.viewControllers.count ?? 0 > 1
        navigationController?.setNavigationBarHidden(!isNeedToShowNavBar, animated: true)
    }

    func configure(profile: Profile) {
        profileViewModel.personalDataViewModel = PersonalDataViewModel(profile: profile)
        profileViewModel.personalDataViewModel.delegate = self
        navigationItem.title = profile.nickname.lowercased()

        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(
            self,
            action: #selector(dotsAction),
            imageName: profileViewModel.dotsIcon,
            tintColor: profileViewModel.iconsColor
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: profileViewModel.leftArrowIconString)?.withTintColor(profileViewModel.iconsColor),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )

        navigationItem.leftBarButtonItem?.tintColor = profileViewModel.iconsColor
    }

    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(containerView)
        containerView.backgroundColor = .clear

        tableView.forAutolayout()
        containerView.forAutolayout()

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.pinTop(to: view),
            tableView.pinBottom(to: view),
            tableView.pinLeading(to: view),
            tableView.pinTrailing(to: view),

            containerView.pinTop(to: view),
            containerView.pinBottom(to: view),
            containerView.pinLeading(to: view),
            containerView.pinTrailing(to: view)
        ])
        containerView.isHidden = true
    }

    private func setupBindings() {
        profileViewModel.onPhotosCellSelected = { [weak self] in
            guard let self else { return }
            let viewModel = PhotoGalleryViewModel(photosTitles: self.profileViewModel.profile.photos)
            let viewController = PhotoGalleryViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private func configureTableView() {
        tableView.allowsSelection = false
        tableView.register(ProfileViewCell.self, forCellReuseIdentifier: ProfileViewCell.identifier)
        tableView.register(PhotosCell.self, forCellReuseIdentifier: PhotosCell.identifier)
        tableView.register(FindMyPostsCell.self, forCellReuseIdentifier: FindMyPostsCell.identifier)
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
    }

    @objc private func dotsAction(){
        print(#file, #line)
        pushDetailsController(type: .information)
    }

    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return profileViewModel.personalDataViewModel.isMyProfile ? 1 : 0
        case 3:
            return 1
        case 4:
            return 1
        default:
            return profileViewModel.posts.filter({$0.author.nickname == profileViewModel.personalDataViewModel.nickname}).count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let personalDataCell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier, for: indexPath) as? ProfileViewCell else { return UITableViewCell() }

                personalDataCell.configure(with: profileViewModel.personalDataViewModel)
            return personalDataCell

        case 1:
            let profileActionsCell = ProfileActionsCell()
            profileActionsCell.configure(viewModels: profileViewModel.actionsViewModels)
            return profileActionsCell

        case 2:
            if profileViewModel.personalDataViewModel.isMyProfile != true {
                fallthrough
            }

            let buttonsIconCell = ProfileIconButtonsCell()
            buttonsIconCell.configure(viewModels: profileViewModel.buttonViewModels)
            return buttonsIconCell
        case 3:
            guard let photosCell = tableView.dequeueReusableCell(withIdentifier: PhotosCell.identifier, for: indexPath) as? PhotosCell else {return UITableViewCell()}
            photosCell.configure(viewModel: profileViewModel.photosCellViewModel)
            return photosCell
        case 4:
            guard let findCell = tableView.dequeueReusableCell(withIdentifier: FindMyPostsCell.identifier, for: indexPath) as? FindMyPostsCell else {return UITableViewCell()}
            if profileViewModel.personalDataViewModel.isMyProfile {
                findCell.configure(viewModel: profileViewModel.findMyPostsViewModel)
            } else {
                findCell.configureFriend(for: profileViewModel.findMyPostsViewModel)
            }
            return findCell
        default:
            guard let postDataCell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UITableViewCell() }
            var post: Post
            if profileViewModel.personalDataViewModel.isMyProfile {

                post = profileViewModel.profile.posts[indexPath.row]
            } else {

                //   post = viewModel.posts[indexPath.row]
                /// -  show posts this friend

                post = profileViewModel.posts.filter({$0.author.nickname == profileViewModel.personalDataViewModel.nickname})[indexPath.row]
            }
                let viewModel = FeedCellViewModel(
                    post: post,
                    indexPath: indexPath,
                    isNeedToShowDotsView: true,
                    isFromFeed: false,
                    delegate: self
                )
            postDataCell.configure(with: viewModel)
            return postDataCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileViewController: FeedCellDelegate {
    func dotsImageTapped(post: Post, indexPath: IndexPath, isMyPost: Bool) {
        if isMyPost {
            containerView.isHidden = false
            tableDotsMenu.view.isUserInteractionEnabled = false
            guard let cell = tableView.cellForRow(at: indexPath) as? FeedCell else { return }
            cell.dotsImage.frame(forAlignmentRect: view.frame)
            let dotsHeight = cell.dotsImage.frame.height
            let point = cell.convert(cell.dotsImage.frame.origin, to: view)
            let newOriginX = point.x - 300
            let newFrame = CGRect(origin: .init(x: newOriginX, y: point.y + dotsHeight / 2), size: .init(width: 300, height: 300))
            tableDotsMenu.layout(frame: newFrame)

            addChildViewController(tableDotsMenu)
            view.contentMode = .center
            let tap = UITapGestureRecognizer(target: self, action: #selector(clearMenuTap))
            view.addGestureRecognizer(tap)
        } else {
            let menuViewController = MenuViewController()

            let floatingPanelController = FloatingPanelController()
            floatingPanelController.delegate = self
            floatingPanelController.surfaceView.layer.cornerRadius = 12
            floatingPanelController.surfaceView.clipsToBounds = true
            floatingPanelController.set(contentViewController: menuViewController)

            floatingPanelController.isRemovalInteractionEnabled = true
            present(floatingPanelController, animated: true)
            floatingPanel = floatingPanelController
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }

    private func calculateFrame(cellFrame: CGRect, dotsFrame: CGRect) -> CGRect {
        let originX = cellFrame.origin.x + dotsFrame.origin.x - 300
        let originY = cellFrame.origin.y + dotsFrame.origin.y + dotsFrame.height / 2
        let width = dotsFrame.width
        let height = dotsFrame.height
        return .init(x: originX, y: originY, width: width, height: height)
    }

    @objc private func clearMenuTap() {
        containerView.isHidden = true
        tableView.isScrollEnabled = true
        tableDotsMenu.prepareForRemove()
    }
}

extension ProfileViewController: ProfileViewDelegate {

    func pushDetailsController(type: DetailedInformationViewType) {
        let viewModel = DetailInformationViewModel(profile: profileViewModel.profile, type: type)
        let detailedViewController = DetailedInformationController(viewModel: viewModel)

        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(detailedViewController, animated: true)
    }

    func showRedactProfileModule() {
        // TODO: - Взять профиль из viewModel
        let profileViewModel = ProfileInformationViewModel(profile: DataBase.shared.testProfile)
        let viewController = ProfileInformationViewController(viewModel: profileViewModel)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
