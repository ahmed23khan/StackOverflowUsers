//
//  NetworkErrorTests.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import XCTest
@testable import StackOverflowUsers

final class NetworkErrorTests: XCTestCase {

    func test_givenUnreachableError_whenGettingDescription_thenMentionsOffline() {
        let error = NetworkError.unreachable
        XCTAssertTrue(error.errorDescription!.lowercased().contains("offline"))
    }

    func test_givenServerError_whenGettingDescription_thenContainsStatusCode() {
        let error = NetworkError.serverError(statusCode: 503)
        XCTAssertTrue(error.errorDescription!.contains("503"))
    }

    func test_givenDecodingFailedError_whenGettingDescription_thenDescriptionIsNotNil() {
        XCTAssertNotNil(NetworkError.decodingFailed.errorDescription)
    }

    func test_givenSameErrorCases_whenComparing_thenAreEqual() {
        XCTAssertEqual(NetworkError.unreachable, NetworkError.unreachable)
        XCTAssertEqual(NetworkError.serverError(statusCode: 404), NetworkError.serverError(statusCode: 404))
    }

    func test_givenDifferentStatusCodes_whenComparing_thenAreNotEqual() {
        XCTAssertNotEqual(
            NetworkError.serverError(statusCode: 404),
            NetworkError.serverError(statusCode: 500)
        )
    }
}
