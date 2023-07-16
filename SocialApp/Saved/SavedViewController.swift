//
//  SavedViewController.swift
//  SocialApp
//
//  Created by Олеся on 19.06.2023.
//

import UIKit

class SavedViewController: UIViewController {

    private lazy var tableView =  UITableView()
    private let coreDataManager = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        coreDataManager.reloadPosts()
        tableView.reloadData()
    }

    private func layout() {
        tableView.forAutolayout()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.pinTop(to: view),
            tableView.pinLeading(to: view),
            tableView.pinTrailing(to: view),
            tableView.pinBottom(to: view)
        ])
    }

    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            let post = self.coreDataManager.favoritesPosts[indexPath.row]
            self.coreDataManager.deleteFavoritePost(favoritePost: post)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            if self.coreDataManager.favoritesPosts.count == 0 {
                print("Deleting. Favorites count is 0")
            }
            print("Deleting. Favorites count is  \(self.coreDataManager.favoritesPosts.count)")
            completionHandler(true)
        }
        return action
    }
}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coreDataManager.favoritesPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UITableViewCell()}
        let post  = coreDataManager.favoritesPosts[indexPath.row]
        cell.configureFavorite(favoritePost: post)
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
}
