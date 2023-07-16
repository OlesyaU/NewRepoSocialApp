//
//  CoreDataManager.swift
//  SocialApp
//
//  Created by Олеся on 10.07.2023.
//

import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()
    var isSaved: ((Bool)-> Void)?

    init(){
        reloadPosts()
    }

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "FavoritePost")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: -  FavoritesPost

    var favoritesPosts: [FavoritePost] = []


    func reloadPosts(){
        let request = FavoritePost.fetchRequest()
        let favotitePosts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.favoritesPosts = favotitePosts
    }

    func addFavoritePost(post: Post?, completion: @escaping ()-> Void) {
        guard let post else {
            print("Post in CoreDataManeger not found")
            return
        }

        persistentContainer.performBackgroundTask { backgroundContext in
            let favoritePost = FavoritePost(context: backgroundContext)
            favoritePost.authorNickname = post.author.nickname
            favoritePost.descriptionPost = post.description
            favoritePost.postImage = UIImage(named: post.image)?.pngData()
            favoritePost.likesCount = Int32(post.likes)
            favoritePost.commentsCount = Int32(post.comments.count)
            favoritePost.isSaved = post.isSaved
            favoritePost.authorAvatar = UIImage(named:post.author.avatar)?.pngData()
            self.isSaved?(post.isSaved)
            do {
                try backgroundContext.save()
            } catch{
                print(error)
            }
            print(post)
            completion()
        }
        reloadPosts()
    }

    func deleteFavoritePost(favoritePost: FavoritePost){
        persistentContainer.viewContext.delete(favoritePost)
        saveContext()
        reloadPosts()
    }


}

