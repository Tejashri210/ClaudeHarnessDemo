import Foundation
import FeedFeature

final class RemoteImageDataLoader: FeedImageDataLoader {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    private class TaskWrapper: ImageLoaderTask {
        var wrapped: URLSessionDataTask?

        func cancel() {
            wrapped?.cancel()
        }
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> ImageLoaderTask {
        let task = TaskWrapper()
        task.wrapped = session.dataTask(with: url) { data, _, error in
            completion(Result {
                if let error = error { throw error }
                return data ?? Data()
            })
        }
        task.wrapped?.resume()
        return task
    }
}
