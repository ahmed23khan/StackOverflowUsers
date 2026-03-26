//
//  FollowStore.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

protocol FollowStore {
    func isFollowing(userId: Int) -> Bool
    func follow(userId: Int)
    func unfollow(userId: Int)
    func followedUserIds() -> Set<Int>
}
