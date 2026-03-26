//
//  UserListViewModel.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import Foundation

@MainActor
final class UserListViewModel {

    // MARK: - State

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded([UserRowViewModel])
        case error(String)
    }

    // MARK: - Output

    let state: Observable<ViewState> = Observable(.idle)
    let refreshError: Observable<String?> = Observable(nil)
    let isRefreshing: Observable<Bool> = Observable(false)

    // MARK: - Dependencies

    private let repository: UserRepository
    private let followStore: FollowStore

    // Cancelled before each new load to prevent stale responses
    // overwriting newer state.
    private var loadTask: Task<Void, Never>?

    // MARK: - Init

    init(repository: UserRepository, followStore: FollowStore) {
        self.repository = repository
        self.followStore = followStore
    }


    func loadUsers(isRefresh: Bool = false) {
        loadTask?.cancel()

        if isRefresh {
            isRefreshing.value = true
        } else {
            state.value = .loading
        }

        loadTask = Task {
            defer { isRefreshing.value = false }

            do {
                let users = try await repository.fetchTopUsers()

                guard !Task.isCancelled else { return }

                guard !users.isEmpty else {
                    if isRefresh {
                        refreshError.value = "No users found."
                    } else {
                        state.value = .error("No users found.")
                    }
                    return
                }

                let rows = users.map { user in
                    UserRowViewModel(
                        user: user,
                        isFollowing: followStore.isFollowing(userId: user.userId)
                    )
                }
                state.value = .loaded(rows)

            } catch is CancellationError {
                return
            } catch let error as NetworkError {
                let message = error.errorDescription ?? "Something went wrong."
                if isRefresh {
                    refreshError.value = message
                } else {
                    state.value = .error(message)
                }
            } catch {
                if isRefresh {
                    refreshError.value = "Something went wrong."
                } else {
                    state.value = .error("Something went wrong.")
                }
            }
        }
    }

    func toggleFollow(for userId: Int) {
        guard case .loaded(var rows) = state.value,
              let index = rows.firstIndex(where: { $0.userId == userId }) else {
            return
        }

        if followStore.isFollowing(userId: userId) {
            followStore.unfollow(userId: userId)
        } else {
            followStore.follow(userId: userId)
        }

        rows[index] = rows[index].withFollowState(followStore.isFollowing(userId: userId))
        state.value = .loaded(rows)
    }
}
