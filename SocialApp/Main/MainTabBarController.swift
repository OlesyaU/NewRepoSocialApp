//
//  MainTabBarController.swift
//  SocialApp
//
//  Created by Олеся on 19.06.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    private let mainTabBarViewModel = MainTabBarViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().backgroundColor = .backgroundPrimary
        viewControllers = [
            createFeedViewController(),
            createProfileViewController(),
            createSavedViewController()
        ]
        view.tintColor = mainTabBarViewModel.tintColorChosenItem
    }

    func createFeedViewController() -> UINavigationController {
        let feed = FeedTableViewController()
        feed.title = mainTabBarViewModel.generalTitle
        feed.tabBarItem = UITabBarItem(title: mainTabBarViewModel.generalTitle, image: UIImage(systemName: mainTabBarViewModel.generalIcon), tag: 0)
        return UINavigationController(rootViewController: feed)
    }

    func createProfileViewController() -> UINavigationController {
        let viewModel = ProfileViewModel(profile: DataBase.shared.testProfile)
        let profile = ProfileViewController(viewModel: viewModel)
        profile.tabBarItem = UITabBarItem(title: mainTabBarViewModel.profileTitle, image: UIImage(systemName: mainTabBarViewModel.profileIcon), tag: 1)
        return  UINavigationController(rootViewController: profile)
    }
    
    func createSavedViewController() -> UINavigationController {
        let saved = SavedViewController()
        saved.title = mainTabBarViewModel.savedTitle
        saved.tabBarItem = UITabBarItem(title: mainTabBarViewModel.savedTitle, image: UIImage(systemName: mainTabBarViewModel.savedIcon), tag: 2)
        return UINavigationController(rootViewController: saved)
    }
}
