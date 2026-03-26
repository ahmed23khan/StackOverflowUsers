//
//  NetworkError.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case decodingFailed
    case serverError(statusCode: Int)
    case unreachable
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unreachable:
            return "You appear to be offline. Check your connection and try again."
        case .serverError(let code):
            return "Something went wrong on the server (Error \(code)). Please try again."
        case .decodingFailed:
            return "We received unexpected data. Please try again later."
        case .invalidURL:
            return "Couldn't build the request URL."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
