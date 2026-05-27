import FeedFeature

protocol FeedLoadingView {
    func display(_ isLoading: Bool)
}

protocol FeedView {
    func display(_ feed: [FeedItem])
}

final class FeedPresenter {
    private let loadingView: FeedLoadingView
    private let feedView: FeedView

    init(loadingView: FeedLoadingView, feedView: FeedView) {
        self.loadingView = loadingView
        self.feedView = feedView
    }

    func didStartLoadingFeed() {
        loadingView.display(true)
    }

    func didFinishLoadingFeed(with feed: [FeedItem]) {
        feedView.display(feed)
        loadingView.display(false)
    }

    func didFinishLoadingFeedWithError() {
        loadingView.display(false)
    }
}
