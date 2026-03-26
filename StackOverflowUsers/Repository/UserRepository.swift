//
//  UserRepository.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

protocol UserRepository {
    func fetchTopUsers() async throws -> [User]
}
