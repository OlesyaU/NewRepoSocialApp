//
//  Profile.swift
//  SocialApp
//
//  Created by Олеся on 19.06.2023.
//

import Foundation

class Profile: Codable, Equatable {
    let avatar: String
    let name: String
    let surname: String
    let profession: String
    var posts: [Post]
    let photos: [String]
    var subscribers: Set<Profile>
    var subscriptions: Set<Profile>
    let city: String
    let dateOfBirth: Date
    let education: String
    let career: String
    let contacts: [Contact]
    let gender: Gender
    var subscribersCount: Int {
        subscribers.count
    }
    var subscriptionsCount: Int {
        subscriptions.count
    }

    var nickname: String {
        name + "_" + surname
    }
    var photosCountString: String {
        String(photos.count)
    }

    init(avatar: String, name: String, surname: String, profession: String, photos: [String], posts: [Post], subscribers: Set<Profile>, subscriptions: Set<Profile>, city: String, dateOfBirth: Date, education: String, career: String, contacts: [Contact], gender: Gender) {
        self.avatar = avatar
        self.name = name
        self.surname = surname
        self.profession = profession
        self.posts = posts
        self.subscribers = subscribers
        self.subscriptions = subscriptions
        self.city = city
        self.dateOfBirth = dateOfBirth
        self.education = education
        self.career = career
        self.contacts = contacts
        self.photos = photos
        self.gender = gender
    }

    static func mock(count: Int) -> [Profile] {
        var profiles: [Profile] = []
        for _ in 0...count {
            let profile = Profile(
                avatar: avatars().randomElement() ?? "" .description,
                name: getAuthorNames().randomElement() ?? "",
                surname: getAuthorSurnames().randomElement() ?? "",
                profession: getProfession().randomElement() ?? "",
                photos: getPhoto().shuffled(),
                posts: [],
                subscribers: [],
                subscriptions: [],
                city: getCity().randomElement() ?? "",
                dateOfBirth: Date(),
                education: getProfession().randomElement() ?? "",
                career: getProfession().randomElement() ?? "",
                contacts: Contact.random(3),
                gender: .female
            )
            profiles.append(profile)
        }
        return profiles
    }
}


extension Profile: Hashable {
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    // TODO: - Implement hashable for posts and contact if needed
    func hash(into hasher: inout Hasher) {
        hasher.combine(avatar)
        hasher.combine(name)
        hasher.combine(surname)
        hasher.combine(profession)
        hasher.combine(city)
        hasher.combine(dateOfBirth)
        hasher.combine(education)
        hasher.combine(career)
    }
}
