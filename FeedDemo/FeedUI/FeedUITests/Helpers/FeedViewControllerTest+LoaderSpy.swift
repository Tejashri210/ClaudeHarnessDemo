import Foundation
import FeedFeature
@testable import FeedUI

class FeedLoaderSpy: FeedLoader, FeedImageDataLoader {

    typealias Error = Swift.Error
    var completions = [(LoadFeedResult) -> Void]()

    var loadCount: Int { return completions.count }

    func load(completion: @escaping (LoadFeedResult) -> Void) {
        completions.append(completion)
    }

    func completeLoading(with feed: [FeedItem] = [], at index: Int) {
        completions[index](.success(feed))
    }

    func completeLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        completions[index](.failure(error))
    }

    private struct TaskSpy: ImageLoaderTask {
        let cancelCallback: () -> Void
        func cancel() {
            cancelCallback()
        }
    }

    var loadedImageURLs: [URL] {
        return imageRequests.map { $0.url }
    }

    var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
    var cancelledImageURLs = [URL]()

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> ImageLoaderTask {
        imageRequests.append((url, completion))
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
    }

    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }

    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        imageRequests[index].completion(.failure(error))
    }
}
