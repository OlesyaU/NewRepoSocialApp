//
//  Post.swift
//  SocialApp
//
//  Created by Олеся on 19.06.2023.
//
import UIKit

struct Post: Codable, Equatable {
    let author: Profile
    let image: String
    let description: String
    var likes: Int
    var comments: [Comment] = []
    var isSaved: Bool
}

extension Post {
    static func mock(count: Int, profile: Profile) -> [Post] {
        var result: [Post] = []
        for _ in 0...count {
            let post = Post(author: profile,
                            image: avatars().randomElement() ?? "",
                            description: lorem,
                            likes: (0...290).randomElement() ?? 0,
                            comments: [],
                            isSaved: Bool.random())
            result.append(post)
        }

        return result
    }
}


