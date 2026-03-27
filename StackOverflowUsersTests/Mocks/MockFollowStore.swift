//
//  MockFollowStore.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

@testable import StackOverflowUsers

final class MockFollowStore: FollowStore {

    private var followed: Set<Int> = []

    var followCallCount = 0
    var unfollowCallCount = 0

    func isFollowing(userId: Int) -> Bool {
        followed.contains(userId)
    }

    func follow(userId: Int) {
        followCallCount += 1
        followed.insert(userId)
    }

    func unfollow(userId: Int) {
        unfollowCallCount += 1
        followed.remove(userId)
    }

    func followedUserIds() -> Set<Int> {
        followed
    }
}
