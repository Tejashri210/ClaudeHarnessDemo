import Foundation
import Moya

public enum FeedAPI {
    case getFeed(url: URL)
}

extension FeedAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getFeed(let url):
            return url.deletingLastPathComponent()
        }
    }

    public var path: String {
        switch self {
        case .getFeed(let url):
            return url.lastPathComponent
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getFeed:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .getFeed:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .getFeed:
            return nil
        }
    }
}

public class MoyaHTTPClient: HTTPClient {
    let provider: MoyaProvider<FeedAPI>

    public init(provider: MoyaProvider<FeedAPI> = MoyaProvider<FeedAPI>()) {
        self.provider = provider
    }

    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        provider.request(.getFeed(url: url)) { result in
            switch result {
            case let .success(response):
                if let httpResponse = response.response {
                    completion(.success((response.data, httpResponse)))
                } else {
                    completion(.failure(NSError(domain: "No HTTPURLResponse", code: 0)))
                }
            case let .failure(error):
                if case let MoyaError.underlying(underlyingError, _) = error {
                    completion(.failure(underlyingError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
