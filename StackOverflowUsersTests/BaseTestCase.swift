//
//  BaseTestCase.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import XCTest
@testable import StackOverflowUsers
@MainActor
class BaseTestCase: XCTestCase {

    var mockRepository: MockUserRepository!
    var mockFollowStore: MockFollowStore!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        mockFollowStore = MockFollowStore()
        mockNetworkService = MockNetworkService()
    }

    override func tearDown() {
        mockRepository = nil
        mockFollowStore = nil
        mockNetworkService = nil
        super.tearDown()
    }
}
