import Foundation
import FeedFeature

final class FeedItemMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
        var feed: [FeedItem] { items.map { $0.item } }
    }

    private struct RemoteFeedItem: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL

        var item: FeedItem {
            FeedItem(id: id,
                     description: description,
                     location: location,
                     imageURL: image)
        }
    }

    private static var OK_200: Int { 200 }

    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        return .success(root.feed)
    }
}
