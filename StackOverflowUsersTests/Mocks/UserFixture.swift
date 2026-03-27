//
//  UserFixture.swift
//  StackOverflowUsersTests
//
//  Created by Tauqeer Khan on 27/03/2026.
//

import Foundation
@testable import StackOverflowUsers

enum UserFixture {

    static func make(
        userId: Int = 1,
        displayName: String = "Ahmed Khan",
        reputation: Int = 1_454_978,
        profileImageURL: URL? = URL(string: "https://example.com/avatar.jpg")
    ) -> User {
        User(
            userId: userId,
            displayName: displayName,
            reputation: reputation,
            profileImageURL: profileImageURL
        )
    }

    static func makeList(count: Int) -> [User] {
        (1...count).map { index in
            make(
                userId: index,
                displayName: "User \(index)",
                reputation: 1000 * index
            )
        }
    }

    static var sampleJSON: Data {
        let json = """
        {
          "items": [
            {
              "user_id": 22656,
              "display_name": "Ahmed Khan",
              "reputation": 1454978,
              "profile_image": "https://example.com/avatar.jpg"
            },
            {
              "user_id": 6309,
              "display_name": "Sachin",
              "reputation": 1290000,
              "profile_image": "https://example.com/vonc.jpg"
            }
          ]
        }
        """
        return Data(json.utf8)
    }

    static var emptyJSON: Data {
        Data(#"{"items":[]}"#.utf8)
    }

    static var malformedJSON: Data {
        Data("not json at all".utf8)
    }
}
