//
//  EndpointTests.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import XCTest
@testable import StackOverflowUsers

final class EndpointTests: XCTestCase {

    func test_givenTopUsersEndpoint_whenBuildingURL_thenURLIsNotNil() {
        XCTAssertNotNil(Endpoint.topUsers(page: 1, pageSize: 20).url)
    }

    func test_givenTopUsersEndpoint_whenBuildingURL_thenHostIsStackExchange() {
        let url = Endpoint.topUsers(page: 1, pageSize: 20).url!
        XCTAssertEqual(url.host, "api.stackexchange.com")
    }

    func test_givenTopUsersEndpoint_whenBuildingURL_thenPathIsCorrect() {
        let url = Endpoint.topUsers(page: 1, pageSize: 20).url!
        XCTAssertEqual(url.path, "/2.2/users")
    }

    func test_givenTopUsersEndpoint_whenBuildingURL_thenPageSizeQueryItemIsPresent() {
        let url = Endpoint.topUsers(page: 1, pageSize: 20).url!
        XCTAssertTrue(url.query?.contains("pagesize=20") ?? false)
    }

    func test_givenTopUsersEndpoint_whenBuildingURL_thenSiteIsStackOverflow() {
        let url = Endpoint.topUsers(page: 1, pageSize: 20).url!
        XCTAssertTrue(url.query?.contains("site=stackoverflow") ?? false)
    }

    func test_givenTopUsersEndpoint_whenBuildingURL_thenOrderIsDescending() {
        let url = Endpoint.topUsers(page: 1, pageSize: 20).url!
        XCTAssertTrue(url.query?.contains("order=desc") ?? false)
    }

    func test_givenTopUsersEndpoint_whenBuildingURL_thenSortIsByReputation() {
        let url = Endpoint.topUsers(page: 1, pageSize: 20).url!
        XCTAssertTrue(url.query?.contains("sort=reputation") ?? false)
    }

    func test_givenTopUsersEndpoint_whenBuildingURL_thenSchemeIsHTTPS() {
        let url = Endpoint.topUsers(page: 1, pageSize: 20).url!
        XCTAssertEqual(url.scheme, "https")
    }
}
