import FeedFeature

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ isLoading: Bool) {
        object?.display(isLoading)
    }
}

extension WeakRefVirtualProxy: FeedView where T: FeedView {
    func display(_ feed: [FeedItem]) {
        object?.display(feed)
    }
}
