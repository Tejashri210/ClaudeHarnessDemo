import UIKit

class FeedCellController {
    private let presenter: FeedImagePresenter<FeedImageCellPresenterAdapter>
    private var cell: FeedImageCell?

    init(presenter: FeedImagePresenter<FeedImageCellPresenterAdapter>) {
        self.presenter = presenter
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedImageCell
        self.cell = cell
        presenter.view = FeedImageCellPresenterAdapter(cell: cell)
        presenter.didStartViewingImage()
        cell.onRetry = presenter.loadImage
        return cell
    }

    func prefetch() {
        presenter.loadImage()
    }

    func cancelLoad() {
        releaseCellForReuse()
        presenter.didStopViewingImage()
    }

    func releaseCellForReuse() {
        cell = nil
    }
}

final class FeedImageCellPresenterAdapter: FeedImageView {
    typealias Image = UIImage
    private weak var cell: FeedImageCell?

    init(cell: FeedImageCell) {
        self.cell = cell
    }

    func displayLocation(_ location: String?) {
        cell?.locationContainer.isHidden = (location == nil)
        cell?.locationLabel.text = location
    }

    func displayDescription(_ description: String?) {
        cell?.descriptionLabel.text = description
    }

    func displayLoadingIndicator(_ isLoading: Bool) {
        if isLoading {
            cell?.imageContainer.startShimmering()
        } else {
            cell?.imageContainer.stopShimmering()
        }
    }

    func display(_ imageData: Image) {
        cell?.feedImageView.image = imageData
        cell?.feedImageRetryButton.isHidden = true
    }

    func displayRetry(_ shouldShow: Bool) {
        cell?.feedImageRetryButton.isHidden = !shouldShow
    }
}
