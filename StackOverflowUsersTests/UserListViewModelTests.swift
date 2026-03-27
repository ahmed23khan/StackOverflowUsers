//
//  UserListViewModelTests.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import XCTest
@testable import StackOverflowUsers

@MainActor
final class UserListViewModelTests: BaseTestCase {

    private var sut: UserListViewModel!

    override func setUp() {
        super.setUp()
        sut = UserListViewModel(repository: mockRepository, followStore: mockFollowStore)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenFreshViewModel_whenInspectingState_thenStateIsIdle() {
        if case .idle = sut.state.value { } else {
            XCTFail("Expected .idle, got \(sut.state.value)")
        }
    }

    func test_givenValidUsers_whenLoadUsers_thenEmitsLoadedStateWithCorrectCount() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 3))

        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .loaded(let rows) = sut.state.value else {
            return XCTFail("Expected .loaded, got \(sut.state.value)")
        }
        XCTAssertEqual(rows.count, 3)
    }

    func test_givenValidUsers_whenLoadUsers_thenRowDisplayNamesMatchUsers() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 2))

        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .loaded(let rows) = sut.state.value else {
            return XCTFail("Expected .loaded")
        }
        XCTAssertEqual(rows[0].displayName, "User 1")
        XCTAssertEqual(rows[1].displayName, "User 2")
    }

    func test_givenEmptyUserList_whenLoadUsers_thenEmitsErrorState() async throws {
        mockRepository.stubbedResult = .success([])

        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .error = sut.state.value else {
            return XCTFail("Expected .error for empty result")
        }
    }

    func test_givenNetworkUnreachable_whenLoadUsers_thenEmitsErrorState() async throws {
        mockRepository.stubbedResult = .failure(.unreachable)

        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .error = sut.state.value else {
            return XCTFail("Expected .error for network failure")
        }
    }

    func test_givenServerError500_whenLoadUsers_thenErrorMessageContainsStatusCode() async throws {
        mockRepository.stubbedResult = .failure(.serverError(statusCode: 500))

        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .error(let message) = sut.state.value else {
            return XCTFail("Expected .error")
        }
        XCTAssertTrue(message.contains("500"))
    }

    func test_givenPreviouslyFollowedUser_whenLoadUsers_thenRowIsMarkedAsFollowing() async throws {
        let users = UserFixture.makeList(count: 3)
        mockFollowStore.follow(userId: 2)
        mockRepository.stubbedResult = .success(users)

        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .loaded(let rows) = sut.state.value else {
            return XCTFail("Expected .loaded")
        }
        XCTAssertFalse(rows[0].isFollowing)
        XCTAssertTrue(rows[1].isFollowing)
        XCTAssertFalse(rows[2].isFollowing)
    }

    func test_givenUnfollowedUser_whenToggleFollow_thenUserIsPersistedToStore() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 1))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        sut.toggleFollow(for: 1)

        XCTAssertTrue(mockFollowStore.isFollowing(userId: 1))
    }

    func test_givenUnfollowedUser_whenToggleFollow_thenRowIsUpdatedToFollowing() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 1))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        sut.toggleFollow(for: 1)

        guard case .loaded(let rows) = sut.state.value else {
            return XCTFail("Expected .loaded")
        }
        XCTAssertTrue(rows[0].isFollowing)
    }

    func test_givenFollowedUser_whenToggleFollow_thenRowIsUpdatedToNotFollowing() async throws {
        mockFollowStore.follow(userId: 1)
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 1))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        sut.toggleFollow(for: 1)

        guard case .loaded(let rows) = sut.state.value else {
            return XCTFail("Expected .loaded")
        }
        XCTAssertFalse(rows[0].isFollowing)
    }

    func test_givenFollowedUser_whenToggleFollow_thenUserIsRemovedFromStore() async throws {
        mockFollowStore.follow(userId: 1)
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 1))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        sut.toggleFollow(for: 1)

        XCTAssertFalse(mockFollowStore.isFollowing(userId: 1))
    }

    func test_givenIdleState_whenToggleFollow_thenNothingHappens() {
        sut.toggleFollow(for: 99)
        XCTAssertEqual(mockFollowStore.followCallCount, 0)
    }

    func test_givenLoadedUsers_whenToggleFollowForUnknownId_thenNothingHappens() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 2))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        sut.toggleFollow(for: 999)

        XCTAssertFalse(mockFollowStore.isFollowing(userId: 999))
    }

    func test_givenAnyState_whenLoadUsers_thenRepositoryIsCalledExactlyOnce() async throws {
        mockRepository.stubbedResult = .success([])
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)
        XCTAssertEqual(mockRepository.fetchCallCount, 1)
    }

    func test_givenLoadedList_whenRefreshSucceeds_thenStateUpdatesToNewRows() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 2))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 5))
        sut.loadUsers(isRefresh: true)
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .loaded(let rows) = sut.state.value else {
            return XCTFail("Expected .loaded after refresh")
        }
        XCTAssertEqual(rows.count, 5)
    }

    func test_givenLoadedList_whenRefreshSucceeds_thenIsRefreshingReturnsFalse() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 2))
        sut.loadUsers(isRefresh: true)
        try await Task.sleep(nanoseconds: 10_000_000)

        XCTAssertFalse(sut.isRefreshing.value)
    }

    func test_givenLoadedList_whenRefreshFails_thenExistingListIsPreserved() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 3))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        mockRepository.stubbedResult = .failure(.unreachable)
        sut.loadUsers(isRefresh: true)
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .loaded(let rows) = sut.state.value else {
            return XCTFail("Expected .loaded state to be preserved after refresh failure")
        }
        XCTAssertEqual(rows.count, 3)
    }

    func test_givenLoadedList_whenRefreshFails_thenRefreshErrorIsEmitted() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 2))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        mockRepository.stubbedResult = .failure(.unreachable)
        sut.loadUsers(isRefresh: true)
        try await Task.sleep(nanoseconds: 10_000_000)

        XCTAssertNotNil(sut.refreshError.value)
    }

    func test_givenLoadedList_whenRefreshFails_thenIsRefreshingReturnsFalse() async throws {
        mockRepository.stubbedResult = .success(UserFixture.makeList(count: 2))
        sut.loadUsers()
        try await Task.sleep(nanoseconds: 10_000_000)

        mockRepository.stubbedResult = .failure(.unreachable)
        sut.loadUsers(isRefresh: true)
        try await Task.sleep(nanoseconds: 10_000_000)

        XCTAssertFalse(sut.isRefreshing.value)
    }

    func test_givenFirstLoad_whenLoadFails_thenMainErrorStateIsSet() async throws {
        mockRepository.stubbedResult = .failure(.unreachable)
        sut.loadUsers(isRefresh: false)
        try await Task.sleep(nanoseconds: 10_000_000)

        guard case .error = sut.state.value else {
            return XCTFail("Expected .error on initial load failure")
        }
    }
}

