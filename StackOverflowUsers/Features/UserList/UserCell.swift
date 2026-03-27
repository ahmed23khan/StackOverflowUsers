//
//  UserCell.swift
//  StackOverflowUsers
//
//  Created by Tauqeer Khan on 26/03/2026.
//

import UIKit

final class UserCell: UITableViewCell {

    static let reuseIdentifier = "UserCell"
    static let nib = UINib(nibName: "UserCell", bundle: nil)

    var onFollowToggle: (() -> Void)?

    private var imageTask: URLSessionDataTask?

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var reputationLabel: UILabel!
    @IBOutlet private weak var followingBadge: UILabel!
    @IBOutlet private weak var followButton: UIButton!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 28
        avatarImageView.clipsToBounds = true
        styleFollowButton(isFollowing: false)
    }

    // MARK: - Configuration

    func configure(with viewModel: UserRowViewModel) {
        nameLabel.text = viewModel.displayName
        reputationLabel.text = "Rep: \(viewModel.reputationText)"
        followingBadge.isHidden = !viewModel.isFollowing
        styleFollowButton(isFollowing: viewModel.isFollowing)
        loadAvatar(url: viewModel.profileImageURL)
    }

    // MARK: - Private

    private func loadAvatar(url: URL?) {
        imageTask?.cancel()
        imageTask = nil
        showPlaceholder()

        guard let url else { return }

        imageTask = ImageLoader.shared.load(url: url) { [weak self] image in
            guard let self, let image else { return }
            self.avatarImageView.image = image
            self.avatarImageView.tintColor = nil
            self.avatarImageView.contentMode = .scaleAspectFill
        }
    }

    private func showPlaceholder() {
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = .systemGray3
        avatarImageView.contentMode = .scaleAspectFit
    }

    private func styleFollowButton(isFollowing: Bool) {
        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 16, bottom: 7, trailing: 16)
        config.title = isFollowing ? "Unfollow" : "Follow"
        config.baseForegroundColor = isFollowing ? .systemRed : .systemBlue
        config.baseBackgroundColor = isFollowing
            ? UIColor.systemRed.withAlphaComponent(0.08)
            : UIColor.systemBlue.withAlphaComponent(0.08)
        followButton.configuration = config
    }

    @IBAction private func followTapped(_ sender: UIButton) {
        onFollowToggle?()
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        onFollowToggle = nil
        followingBadge.isHidden = true
        showPlaceholder()
    }
}
