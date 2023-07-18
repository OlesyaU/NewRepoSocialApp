//
//  PublicationViewController.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//

import UIKit
import FloatingPanel
protocol PublicationControllerProtocol {
    func openPostMenuFromProfile(post: Post, indexPath: IndexPath)
    func showMenuViewController()
}


class PublicationViewController: UIViewController, FloatingPanelControllerDelegate {

    private var viewModel: PublicationViewModel?
    private var floatingPanel: FloatingPanelController?
    private let tableDotsMenu = ProfileDotsController()
    private let leaveCommentView = LeaveCommentView()
    private let containerView = UIView()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureTableView()
    }

    func configure(post: Post) {
        viewModel = PublicationViewModel(post: post)
        guard let viewModel = viewModel else {return}
        leaveCommentView.configure(viewModel: viewModel)
        navigationItem.title = viewModel.titleController

        navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(
            self,
            action: #selector(dotsAction),
            imageName: viewModel.dotsIconName,
            tintColor: viewModel.colorNickname
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: viewModel.arrowIcon)?.withTintColor(viewModel.colorNickname),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )
        navigationItem.leftBarButtonItem?.tintColor = viewModel.colorNickname
    }
    private func setupConstraints() {
        [tableView, containerView, leaveCommentView].forEach({$0.forAutolayout()})
        [tableView, containerView, leaveCommentView].forEach({view.addSubview($0)})

        containerView.backgroundColor = .clear

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
            containerView.pinTrailing(to: view),

            leaveCommentView.pinLeading(to: view.safeAreaLayoutGuide.leadingAnchor),
            leaveCommentView.pinTrailing(to: view.safeAreaLayoutGuide.trailingAnchor),
            leaveCommentView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)        ])
        containerView.isHidden = true
    }

    private func configureTableView() {
        tableView.allowsSelection = false
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
    }

    @objc private func dotsAction(){
        print(#file, #line)
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

    @objc private func backAction(){
        navigationController?.popViewController(animated: true)
    }
}

extension PublicationViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return viewModel?.post.comments.count ?? 0
            default:
                return .zero
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = viewModel?.post else { return UITableViewCell() }
        switch indexPath.section {
            case 0:
                let postCell = FeedCell()
                let viewModel = FeedCellViewModel(
                    post: post,
                    indexPath: indexPath,
                    isNeedToShowDotsView: false,
                    isFromFeed: true,
                    delegate: self
                )
//                postCell.configurePublicationCell(post: POST)
                postCell.configure(with: viewModel)
                return postCell
            case 1:
                let cell = FindMyPostsCell()
                cell.configureForComments(for: post)
                return cell
            case 2:
                guard let singleCommentCell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell,
                      post.comments.count > indexPath.row
                else {return UITableViewCell()}
                let viewModel = CommentViewModel(comment: post.comments[indexPath.row])
                singleCommentCell.configure(viewModel: viewModel)
                return singleCommentCell
            default:
                return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension PublicationViewController: FeedCellDelegate {
    func headerTapped(with postAuthor: Profile) {
        let viewModel = ProfileViewModel(profile: postAuthor)
        let profileVC = ProfileViewController(viewModel: viewModel)
        profileVC.configure(profile: postAuthor)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
