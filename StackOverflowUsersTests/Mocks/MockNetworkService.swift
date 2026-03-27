//
//  MockNetworkService.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import Foundation
@testable import StackOverflowUsers

final class MockNetworkService: NetworkService {

    var stubbedData: Data?
    var stubbedError: NetworkError?
    var fetchCallCount = 0

    func fetch<T: Decodable>(from url: URL) async throws -> T {
        fetchCallCount += 1

        if let error = stubbedError {
            throw error
        }

        guard let data = stubbedData else {
            throw NetworkError.unknown
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
