//
//  UserRowViewModelTests.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import XCTest
@testable import StackOverflowUsers

final class UserRowViewModelTests: XCTestCase {

    func test_givenReputationUnderThousand_whenFormatting_thenShowsRawNumber() {
        let sut = UserRowViewModel(user: UserFixture.make(reputation: 800), isFollowing: false)
        XCTAssertEqual(sut.reputationText, "800")
    }

    func test_givenReputationOfExactlyOneThousand_whenFormatting_thenShowsKFormat() {
        let sut = UserRowViewModel(user: UserFixture.make(reputation: 1_000), isFollowing: false)
        XCTAssertEqual(sut.reputationText, "1.0k")
    }

    func test_givenReputationInThousands_whenFormatting_thenShowsKFormat() {
        let sut = UserRowViewModel(user: UserFixture.make(reputation: 34_200), isFollowing: false)
        XCTAssertEqual(sut.reputationText, "34.2k")
    }

    func test_givenReputationOfExactlyOneMillion_whenFormatting_thenShowsMFormat() {
        let sut = UserRowViewModel(user: UserFixture.make(reputation: 1_000_000), isFollowing: false)
        XCTAssertEqual(sut.reputationText, "1.0M")
    }

    func test_givenHighReputation_whenFormatting_thenShowsMFormatRounded() {
        let sut = UserRowViewModel(user: UserFixture.make(reputation: 1_454_978), isFollowing: false)
        XCTAssertEqual(sut.reputationText, "1.5M")
    }

    func test_givenFollowingTrue_whenInitialising_thenIsFollowingIsTrue() {
        let sut = UserRowViewModel(user: UserFixture.make(), isFollowing: true)
        XCTAssertTrue(sut.isFollowing)
    }

    func test_givenFollowingFalse_whenInitialising_thenIsFollowingIsFalse() {
        let sut = UserRowViewModel(user: UserFixture.make(), isFollowing: false)
        XCTAssertFalse(sut.isFollowing)
    }

    func test_givenNotFollowing_whenWithFollowStateTrue_thenReturnsFollowingViewModel() {
        let original = UserRowViewModel(user: UserFixture.make(), isFollowing: false)
        let updated = original.withFollowState(true)
        XCTAssertTrue(updated.isFollowing)
    }

    func test_givenViewModel_whenWithFollowStateCalled_thenOtherFieldsArePreserved() {
        let user = UserFixture.make(userId: 42, displayName: "Ahmed Khan", reputation: 500)
        let original = UserRowViewModel(user: user, isFollowing: false)
        let updated = original.withFollowState(true)

        XCTAssertEqual(updated.userId, 42)
        XCTAssertEqual(updated.displayName, "Ahmed Khan")
        XCTAssertEqual(updated.reputationText, "500")
    }

    func test_givenViewModel_whenWithFollowStateCalled_thenOriginalIsNotMutated() {
        let original = UserRowViewModel(user: UserFixture.make(), isFollowing: false)
        _ = original.withFollowState(true)
        XCTAssertFalse(original.isFollowing)
    }
}
