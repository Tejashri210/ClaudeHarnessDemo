import FeedFeature
import UIKit

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    // MARK: - FeedView

    func display(_ feed: [FeedItem]) {
        controller?.cellControllers = feed.map { feedItem in
            let imageTransformer = UIImage.init(data:)
            let presenter = FeedImagePresenter<FeedImageCellPresenterAdapter>(
                feedItem: feedItem,
                imageLoader: imageLoader,
                imageTransformer: imageTransformer
            )
            return FeedCellController(presenter: presenter)
        }
    }
}
