//
//  DefaultUserRepositoryTests.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import XCTest
@testable import StackOverflowUsers

final class DefaultUserRepositoryTests: BaseTestCase {

    private var sut: DefaultUserRepository!

    override func setUp() {
        super.setUp()
        sut = DefaultUserRepository(networkService: mockNetworkService)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Success

    func test_givenValidJSON_whenFetchTopUsers_thenReturnsCorrectUserCount() async throws {
        mockNetworkService.stubbedData = UserFixture.sampleJSON

        let users = try await sut.fetchTopUsers()

        XCTAssertEqual(users.count, 2)
    }

    func test_givenValidJSON_whenFetchTopUsers_thenFirstUserHasCorrectName() async throws {
        mockNetworkService.stubbedData = UserFixture.sampleJSON

        let users = try await sut.fetchTopUsers()

        XCTAssertEqual(users.first?.displayName, "Ahmed Khan")
    }

    func test_givenValidJSON_whenFetchTopUsers_thenReputationIsParsedCorrectly() async throws {
        mockNetworkService.stubbedData = UserFixture.sampleJSON

        let users = try await sut.fetchTopUsers()

        XCTAssertEqual(users.first?.reputation, 1_454_978)
    }

    // MARK: - Failure

    func test_givenNetworkUnreachable_whenFetchTopUsers_thenThrowsUnreachableError() async {
        mockNetworkService.stubbedError = .unreachable
        
        do {
            _ = try await sut.fetchTopUsers()
            XCTFail("Expected throw")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unreachable)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_givenMalformedJSON_whenFetchTopUsers_thenThrowsDecodingError() async {
        mockNetworkService.stubbedData = UserFixture.malformedJSON
        
        do {
            _ = try await sut.fetchTopUsers()
            XCTFail("Expected throw")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Call count

    func test_givenValidJSON_whenFetchTopUsers_thenNetworkServiceCalledOnce() async throws {
        mockNetworkService.stubbedData = UserFixture.sampleJSON
        _ = try await sut.fetchTopUsers()
        XCTAssertEqual(mockNetworkService.fetchCallCount, 1)
    }
}
