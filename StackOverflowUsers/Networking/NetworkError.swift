//
//  NetworkError.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import Foundation

enum Endpoint {
    case topUsers(page: Int, pageSize: Int)

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.stackexchange.com"
        components.path = "/2.2/users"
        components.queryItems = queryItems
        return components.url
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .topUsers(let page, let pageSize):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pagesize", value: "\(pageSize)"),
                URLQueryItem(name: "order", value: "desc"),
                URLQueryItem(name: "sort", value: "reputation"),
                URLQueryItem(name: "site", value: "stackoverflow")
            ]
        }
    }
}
