//
//  NetworkService.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import Foundation

protocol NetworkService {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}
