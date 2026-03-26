//
//  UserRowViewModel.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import Foundation

struct UserRowViewModel: Equatable {
    let userId: Int
    let displayName: String
    let reputationText: String
    let profileImageURL: URL?
    let isFollowing: Bool

    init(user: User, isFollowing: Bool) {
        self.userId = user.userId
        self.displayName = user.displayName
        self.reputationText = UserRowViewModel.formatted(reputation: user.reputation)
        self.profileImageURL = user.profileImageURL
        self.isFollowing = isFollowing
    }

    private init(
        userId: Int,
        displayName: String,
        reputationText: String,
        profileImageURL: URL?,
        isFollowing: Bool
    ) {
        self.userId = userId
        self.displayName = displayName
        self.reputationText = reputationText
        self.profileImageURL = profileImageURL
        self.isFollowing = isFollowing
    }

    func withFollowState(_ following: Bool) -> UserRowViewModel {
        UserRowViewModel(
            userId: userId,
            displayName: displayName,
            reputationText: reputationText,
            profileImageURL: profileImageURL,
            isFollowing: following
        )
    }

    // 1454978 → "1.5M", 34200 → "34.2k", 800 → "800"
    private static func formatted(reputation: Int) -> String {
        switch reputation {
        case 1_000_000...:
            return String(format: "%.1fM", Double(reputation) / 1_000_000)
        case 1_000...:
            return String(format: "%.1fk", Double(reputation) / 1_000)
        default:
            return "\(reputation)"
        }
    }
}
