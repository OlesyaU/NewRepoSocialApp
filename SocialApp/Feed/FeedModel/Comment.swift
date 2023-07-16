//
//  Comment.swift
//  SocialApp
//
//  Created by Олеся on 04.07.2023.
//

import Foundation
struct Comment: Codable, Equatable {
    let author: Profile
    let text: String
    let date: Date
    var likedBy: [Profile]
    var likes: Int { likedBy.count }
    var isLiked: Bool {
        likedBy.contains(DataBase.shared.testProfile)
    }
    init(author: Profile, text: String, date: Date, likedBy: [Profile]) {
        self.text = text
        self.date = date
        self.likedBy = likedBy
        self.author = author
    }
}

extension Comment {
    static func mock(count: Int, for profiles: [Profile]) -> [Comment] {
        var result: [Comment] = []
        for _ in 0...count {
            guard let randomAuthor = profiles.randomElement() else { return [] }

            var randomProfiles: [Profile] = []
            for i in 0..<profiles.count {
                if Bool.random() {
                    randomProfiles.append(profiles[i])
                }
            }

            let comment = Comment(
                author: randomAuthor,
                text: getCommentText().randomElement() ?? "",
                date: Date(),
                likedBy: randomProfiles
            )
            
            result.append(comment)
        }
        return result
    }
}
