//
//  DefaultUserRepository.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import Foundation

final class DefaultUserRepository: UserRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchTopUsers() async throws -> [User] {
        guard let url = Endpoint.topUsers(page: 1, pageSize: 20).url else {
            throw NetworkError.invalidURL
        }
        let response: UsersResponse = try await networkService.fetch(from: url)
        return response.items
    }
}
