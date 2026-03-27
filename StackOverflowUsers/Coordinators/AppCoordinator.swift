//
//  AppCoordinator.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import UIKit

final class AppCoordinator: Coordinator {

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @MainActor
    func start() {
        guard let viewController = navigationController.topViewController as? UserListViewController else {
            return
        }

        let networkService = URLSessionNetworkService()
        let repository = DefaultUserRepository(networkService: networkService)
        let followStore = UserDefaultsFollowStore()
        viewController.viewModel = UserListViewModel(repository: repository, followStore: followStore)
    }
}
