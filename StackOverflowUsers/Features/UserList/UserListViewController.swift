//
//  UserListViewController.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import UIKit

final class UserListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.onRetry = { [weak self] in self?.viewModel.loadUsers() }
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()


    var viewModel: UserListViewModel!
    private var rows: [UserRowViewModel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        precondition(viewModel != nil, "UserListViewController requires a viewModel — check AppCoordinator.start()")
        super.viewDidLoad()
        setupTableView()
        setupOverlays()
        bindViewModel()
        viewModel.loadUsers()
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.register(UserCell.nib, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 96
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
    }

    private func setupOverlays() {
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    private func bindViewModel() {
        viewModel.state.observe { [weak self] state in
            self?.render(state: state)
        }

        viewModel.isRefreshing.observe { [weak self] refreshing in
            if !refreshing {
                self?.refreshControl.endRefreshing()
            }
        }

        viewModel.refreshError.observe { [weak self] message in
            guard let message else { return }
            self?.showRefreshError(message)
        }
    }

    private func render(state: UserListViewModel.ViewState) {
        switch state {
        case .idle:
            break

        case .loading:
            loadingIndicator.startAnimating()
            tableView.isHidden = true
            emptyStateView.isHidden = true

        case .loaded(let rows):
            self.rows = rows
            loadingIndicator.stopAnimating()
            tableView.isHidden = false
            emptyStateView.isHidden = true
            tableView.reloadData()

        case .error(let message):
            loadingIndicator.stopAnimating()
            tableView.isHidden = true
            emptyStateView.isHidden = false
            emptyStateView.configure(message: message)
        }
    }

    private func showRefreshError(_ message: String) {
        let alert = UIAlertController(title: "Refresh Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Clear after dismissal so stale error state doesn't linger.
            self?.viewModel.refreshError.value = nil
        })
        present(alert, animated: true)
    }

    @objc private func handleRefresh() {
        viewModel.loadUsers(isRefresh: true)
    }
}

// MARK: - UITableViewDataSource

extension UserListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserCell.reuseIdentifier,
            for: indexPath
        ) as? UserCell else {
            return UITableViewCell()
        }

        let row = rows[indexPath.row]
        cell.configure(with: row)
        cell.onFollowToggle = { [weak self] in
            self?.viewModel.toggleFollow(for: row.userId)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UserListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
