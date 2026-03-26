//
//  UserDefaultsFollowStore.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import Foundation

final class UserDefaultsFollowStore: FollowStore {

    private let defaults: UserDefaults
    // Namespaced to avoid UserDefaults key collisions
    private let storageKey = "com.tauqeerkhan.StackOverflowUsers.followedUserIds"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func isFollowing(userId: Int) -> Bool {
        followedUserIds().contains(userId)
    }

    func follow(userId: Int) {
        var ids = followedUserIds()
        ids.insert(userId)
        persist(ids)
    }

    func unfollow(userId: Int) {
        var ids = followedUserIds()
        ids.remove(userId)
        persist(ids)
    }

    func followedUserIds() -> Set<Int> {
        let stored = defaults.array(forKey: storageKey) as? [Int] ?? []
        return Set(stored)
    }

    private func persist(_ ids: Set<Int>) {
        defaults.set(Array(ids), forKey: storageKey)
    }
}
