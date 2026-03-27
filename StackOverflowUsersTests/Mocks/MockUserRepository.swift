//
//  MockUserRepository.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

@testable import StackOverflowUsers

final class MockUserRepository: UserRepository {

    var stubbedResult: Result<[User], NetworkError> = .success([])
    var fetchCallCount = 0

    func fetchTopUsers() async throws -> [User] {
        fetchCallCount += 1
        switch stubbedResult {
        case .success(let users): return users
        case .failure(let error): throw error
        }
    }
}
