import XCTest
@testable import FeedCache

class FeedStoreIntegrationTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()

        try setupEmptyStoreState()
    }

    override func tearDownWithError() throws {
        try undoStoreSideEffects()

        try super.tearDownWithError()
    }

    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        let sut = try makeSUT()

        expect(sut, toRetrieve: .empty)
    }

    func test_retrieve_deliversFeedInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToLoad = try makeSUT()
        let feed = uniqueImageFeed()
        let timestamp = Date()

        insert((feed, timestamp), to: storeToInsert)

        expect(storeToLoad, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }

    func test_insert_overridesFeedInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToOverride = try makeSUT()
        let storeToLoad = try makeSUT()

        insert((uniqueImageFeed(), Date()), to: storeToInsert)

        let latestFeed = uniqueImageFeed()
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: storeToOverride)

        expect(storeToLoad, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp))
    }

    func test_delete_deletesFeedInsertedOnAnotherInstance() throws {
        let storeToInsert = try makeSUT()
        let storeToDelete = try makeSUT()
        let storeToLoad = try makeSUT()

        insert((uniqueImageFeed(), Date()), to: storeToInsert)

        deleteCache(from: storeToDelete)

        expect(storeToLoad, toRetrieve: .empty)
    }

    func test_deleteOldCachedImages_deletesImagesOlderThan7Days() throws {
        let storeToInsert = try makeSUT()
        let storeToDelete = try makeSUT()
        let storeToLoad = try makeSUT()

        let eightDaysAgo = Calendar.current.date(byAdding: .day, value: -8, to: Date())!
        let sixDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        let oldFeed = uniqueImageFeed()
        let recentFeed = uniqueImageFeed()

        insert((oldFeed, eightDaysAgo), to: storeToInsert)
        insert((recentFeed, sixDaysAgo), to: storeToInsert)

        deleteOldCachedImages(from: storeToDelete as! CoreDataFeedStore)

        expect(storeToLoad, toRetrieve: .found(feed: recentFeed, timestamp: sixDaysAgo))
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> FeedStore {
        let sut = try CoreDataFeedStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func setupEmptyStoreState() throws {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() throws {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }

    private func testSpecificStoreURL() -> URL {
        .cachesDirectory.appendingPathComponent("\(type(of: self)).store")
    }
}
