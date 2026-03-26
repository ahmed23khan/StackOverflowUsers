//
//  User.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import Foundation

struct User: Equatable {
    let userId: Int
    let displayName: String
    let reputation: Int
    let profileImageURL: URL?

    init(userId: Int, displayName: String, reputation: Int, profileImageURL: URL?) {
        self.userId = userId
        self.displayName = displayName
        self.reputation = reputation
        self.profileImageURL = profileImageURL
    }
}

extension User: Decodable {

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case displayName = "display_name"
        case reputation
        case profileImage = "profile_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(Int.self, forKey: .userId)
        displayName = try container.decode(String.self, forKey: .displayName)
        reputation = try container.decode(Int.self, forKey: .reputation)
        // API returns this as a string, convert to URL here
        let imageString = try container.decodeIfPresent(String.self, forKey: .profileImage)
        profileImageURL = imageString.flatMap { URL(string: $0) }
    }
}
