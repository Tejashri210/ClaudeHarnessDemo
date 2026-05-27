import UIKit

final class FeedImageCell: UITableViewCell {
    @IBOutlet var locationContainer: UIView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var feedImageRetryButton: UIButton!

    var onRetry: (() -> Void)?

    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
