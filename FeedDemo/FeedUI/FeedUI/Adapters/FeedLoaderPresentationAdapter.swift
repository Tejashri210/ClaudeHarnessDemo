import Foundation
import FeedFeature

final class FeedLoaderPresentationAdapter: FeedRefreshDelegate {
    private let feedLoader: any FeedLoader
    var presenter: FeedPresenter?

    init(feedLoader: any FeedLoader) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(feed):
                    self?.presenter?.didFinishLoadingFeed(with: feed)
                case .failure:
                    self?.presenter?.didFinishLoadingFeedWithError()
                }
            }
        }
    }
}
