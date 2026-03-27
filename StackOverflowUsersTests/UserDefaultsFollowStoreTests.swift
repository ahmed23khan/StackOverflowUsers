//
//  UserDefaultsFollowStoreTests.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import XCTest
@testable import StackOverflowUsers

final class UserDefaultsFollowStoreTests: XCTestCase {

    private var sut: UserDefaultsFollowStore!
    private var testDefaults: UserDefaults!
    private let suiteName = "com.tauqeerkhan.StackOverflowUsers.tests.followStore"

    override func setUp() {
        super.setUp()
        testDefaults = UserDefaults(suiteName: suiteName)
        sut = UserDefaultsFollowStore(defaults: testDefaults)
    }

    override func tearDown() {
        testDefaults.removePersistentDomain(forName: suiteName)
        sut = nil
        testDefaults = nil
        super.tearDown()
    }

    func test_givenFreshStore_whenCheckingFollowStatus_thenReturnsFalse() {
        XCTAssertFalse(sut.isFollowing(userId: 42))
    }

    func test_givenFreshStore_whenGettingFollowedIds_thenReturnsEmptySet() {
        XCTAssertTrue(sut.followedUserIds().isEmpty)
    }

    func test_givenUnfollowedUser_whenFollow_thenUserIsFollowing() {
        sut.follow(userId: 1)
        XCTAssertTrue(sut.isFollowing(userId: 1))
    }

    func test_givenMultipleUsers_whenFollowBoth_thenBothAreInFollowedSet() {
        sut.follow(userId: 1)
        sut.follow(userId: 2)
        XCTAssertEqual(sut.followedUserIds(), [1, 2])
    }

    func test_givenFollowedUser_whenUnfollow_thenUserIsNotFollowing() {
        sut.follow(userId: 1)
        sut.unfollow(userId: 1)
        XCTAssertFalse(sut.isFollowing(userId: 1))
    }

    func test_givenNeverFollowedUser_whenUnfollow_thenNoCrashAndStillNotFollowing() {
        sut.unfollow(userId: 99)
        XCTAssertFalse(sut.isFollowing(userId: 99))
    }

    func test_givenTwoFollowedUsers_whenUnfollowOne_thenOtherRemainsFollowed() {
        sut.follow(userId: 1)
        sut.follow(userId: 2)
        sut.unfollow(userId: 1)
        XCTAssertFalse(sut.isFollowing(userId: 1))
        XCTAssertTrue(sut.isFollowing(userId: 2))
    }

}
