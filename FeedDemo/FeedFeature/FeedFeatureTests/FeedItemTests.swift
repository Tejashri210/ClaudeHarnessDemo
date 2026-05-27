import Testing
import Foundation
import FeedFeature

struct FeedItemTests {

    @Test func feedItem_init_setsAllProperties() {
        let id = UUID()
        let url = URL(string: "https://any-url.com")!
        let description = "a description"
        let location = "a location"

        let item = FeedItem(id: id, description: description, location: location, imageURL: url)

        #expect(item.id == id)
        #expect(item.description == description)
        #expect(item.location == location)
        #expect(item.imageURL == url)
    }

    @Test func feedItem_init_optionalPropertiesDefaultToNil() {
        let id = UUID()
        let url = URL(string: "https://any-url.com")!

        let item = FeedItem(id: id, imageURL: url)

        #expect(item.description == nil)
        #expect(item.location == nil)
    }

    @Test func feedItem_equality_twoIdenticalItemsAreEqual() {
        let id = UUID()
        let url = URL(string: "https://any-url.com")!

        let item1 = FeedItem(id: id, description: "desc", location: "loc", imageURL: url)
        let item2 = FeedItem(id: id, description: "desc", location: "loc", imageURL: url)

        #expect(item1 == item2)
    }

    @Test func feedItem_equality_differentIdMakesNotEqual() {
        let url = URL(string: "https://any-url.com")!

        let item1 = FeedItem(id: UUID(), imageURL: url)
        let item2 = FeedItem(id: UUID(), imageURL: url)

        #expect(item1 != item2)
    }
}
