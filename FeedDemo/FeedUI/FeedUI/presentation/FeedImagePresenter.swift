import Foundation
import FeedFeature

protocol FeedImageView {
    associatedtype Image

    func displayLocation(_ location: String?)
    func displayDescription(_ description: String?)
    func displayLoadingIndicator(_ isLoading: Bool)
    func display(_ image: Image)
    func displayRetry(_ shouldShow: Bool)
}

final class FeedImagePresenter<View: FeedImageView> {
    private let feedItem: FeedItem
    private let imageLoader: FeedImageDataLoader
    private var task: ImageLoaderTask?
    private let imageTransformer: (Data) -> View.Image?
    var view: View?

    init(feedItem: FeedItem, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> View.Image?) {
        self.feedItem = feedItem
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }

    func didStartViewingImage() {
        view?.displayLocation(feedItem.location)
        view?.displayDescription(feedItem.description)
        loadImage()
    }

    func loadImage() {
        view?.displayLoadingIndicator(true)
        view?.displayRetry(false)

        task = imageLoader.loadImageData(from: feedItem.imageURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let image = self?.imageTransformer(data) else {
                        self?.view?.displayRetry(true)
                        return
                    }
                    self?.view?.display(image)
                    self?.view?.displayRetry(false)
                case .failure:
                    self?.view?.displayRetry(true)
                }
                self?.view?.displayLoadingIndicator(false)
            }
        }
    }

    func didStopViewingImage() {
        task?.cancel()
    }
}
