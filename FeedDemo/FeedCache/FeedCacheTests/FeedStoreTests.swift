import CoreData
import XCTest
@testable import FeedCache

class FeedStoreTests: XCTestCase, FailableFeedStoreSpecs {

    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws {
        let sut = try makeSUT()

        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws {
        let sut = try makeSUT()

        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }

    func test_retrieve_deliversFailureOnRetrievalError() throws {
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()

        let sut = try makeSUT()

        assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
    }

    func test_retrieve_hasNoSideEffectsOnFailure() throws {
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()

        let sut = try makeSUT()

        assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
    }

    func test_insert_deliversNoErrorOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }

    func test_insert_deliversNoErrorOnNonEmptyCache() throws {
        let sut = try makeSUT()

        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }

    func test_insert_overridesPreviouslyInsertedCacheValues() throws {
        let sut = try makeSUT()

        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }

    func test_insert_deliversErrorOnInsertionError() throws {
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()

        let sut = try makeSUT()

        assertThatInsertDeliversErrorOnInsertionError(on: sut)
    }

    func test_insert_hasNoSideEffectsOnInsertionError() throws {
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()

        let sut = try makeSUT()

        assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
    }

    func test_delete_deliversNoErrorOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }

    func test_delete_hasNoSideEffectsOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }

    func test_delete_deliversNoErrorOnNonEmptyCache() throws {
        let sut = try makeSUT()

        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }

    func test_delete_emptiesPreviouslyInsertedCache() throws {
        let sut = try makeSUT()

        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }

    func test_delete_deliversErrorOnDeletionError() throws {
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        let feed = uniqueImageFeed()
        let timestamp = Date()
        let sut = try makeSUT()

        insert((feed, timestamp), to: sut)

        stub.startIntercepting()

        let deletionError = deleteCache(from: sut)

        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
    }

    func test_delete_hasNoSideEffectsOnDeletionError() throws {
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        let feed = uniqueImageFeed()
        let timestamp = Date()
        let sut = try makeSUT()

        insert((feed, timestamp), to: sut)

        stub.startIntercepting()

        deleteCache(from: sut)

        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }

    func test_delete_removesAllObjects() throws {
        let store = try makeSUT()

        insert((uniqueImageFeed(), Date()), to: store)

        deleteCache(from: store)

        let context = try NSPersistentContainer.load(
            name: CoreDataFeedStore.modelName,
            model: XCTUnwrap(CoreDataFeedStore.model),
            url: inMemoryStoreURL()
        ).viewContext

        let existingObjects = try context.allExistingObjects()

        XCTAssertEqual(existingObjects, [], "found orphaned objects in Core Data")
    }

    func test_storeSideEffects_runSerially() throws {
        let sut = try makeSUT()

        assertThatSideEffectsRunSerially(on: sut)
    }

    func test_deleteCachedFeedImagesOlderThanSevenDays_deliversNoErrorOnEmptyCache() throws {
        let sut = try makeSUT()

        let deletionError = deleteCachedImagesOlderThanSevenDays(from: sut)

        XCTAssertNil(deletionError, "Expected successful deletion on empty cache")
    }

    func test_deleteCachedFeedImagesOlderThanSevenDays_hasNoSideEffectsOnEmptyCache() throws {
        let sut = try makeSUT()

        deleteCachedImagesOlderThanSevenDays(from: sut)

        expect(sut, toRetrieve: .empty)
    }

    func test_deleteCachedFeedImagesOlderThanSevenDays_deliversNoErrorOnNonEmptyCache() throws {
        let sut = try makeSUT()
        let feed = uniqueImageFeed()
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        let deletionError = deleteCachedImagesOlderThanSevenDays(from: sut)

        XCTAssertNil(deletionError, "Expected successful deletion on non-empty cache")
    }

    func test_deleteCachedFeedImagesOlderThanSevenDays_removesCachedImageDataOlderThanSevenDays() throws {
        let sut = try makeSUT()
        let feed = uniqueImageFeed()
        let timestamp = Date()
        let oldImageData = "old image data".data(using: .utf8)!
        let recentImageData = "recent image data".data(using: .utf8)!
        let nineDaysAgo = Calendar.current.date(byAdding: .day, value: -9, to: Date())!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!

        insert((feed, timestamp), to: sut)
        setCachedImageData(oldImageData, cachedAt: nineDaysAgo, for: feed[0], in: sut)
        setCachedImageData(recentImageData, cachedAt: twoDaysAgo, for: feed[1], in: sut)

        deleteCachedImagesOlderThanSevenDays(from: sut)

        verifyCachedImageData(nil, for: feed[0], in: sut)
        verifyCachedImageData(recentImageData, for: feed[1], in: sut)
    }
    
    func test_imageEntity_properties() throws {
        let entity = try XCTUnwrap(
            CoreDataFeedStore.model?.entitiesByName["FeedImage"]
        )

        entity.verify(attribute: "id", hasType: .UUIDAttributeType, isOptional: false)
        entity.verify(attribute: "imageDescription", hasType: .stringAttributeType, isOptional: true)
        entity.verify(attribute: "location", hasType: .stringAttributeType, isOptional: true)
        entity.verify(attribute: "url", hasType: .URIAttributeType, isOptional: false)
        entity.verify(attribute: "data", hasType: .binaryDataAttributeType, isOptional: true)
        entity.verify(attribute: "cachedAt", hasType: .dateAttributeType, isOptional: true)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> FeedStore {
        let sut = try CoreDataFeedStore(storeURL: inMemoryStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func inMemoryStoreURL() -> URL {
        URL(fileURLWithPath: "/dev/null")
            .appendingPathComponent("\(type(of: self)).store")
    }

    private func deleteCachedImagesOlderThanSevenDays(from sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for deletion completion")
        var deletionError: Error?

        (sut as! CoreDataFeedStore).deleteCachedFeedImagesOlderThanSevenDays { error in
            deletionError = error
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return deletionError
    }

    private func setCachedImageData(_ data: Data, cachedAt: Date, for image: LocalFeedImage, in sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache update")

        let store = sut as! CoreDataFeedStore
        store.perform { context in
            let fetchRequest = NSFetchRequest<FeedImage>(entityName: "FeedImage")
            fetchRequest.predicate = NSPredicate(format: "id == %@", image.id as CVarArg)

            do {
                let results = try context.fetch(fetchRequest)
                if let feedImage = results.first {
                    feedImage.data = data
                    feedImage.cachedAt = cachedAt
                    try context.save()
                }
                exp.fulfill()
            } catch {
                XCTFail("Failed to set cached image data: \(error)", file: file, line: line)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }

    private func verifyCachedImageData(_ expectedData: Data?, for image: LocalFeedImage, in sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for verification")

        let store = sut as! CoreDataFeedStore
        store.perform { context in
            let fetchRequest = NSFetchRequest<FeedImage>(entityName: "FeedImage")
            fetchRequest.predicate = NSPredicate(format: "id == %@", image.id as CVarArg)

            do {
                let results = try context.fetch(fetchRequest)
                if let feedImage = results.first {
                    XCTAssertEqual(feedImage.data, expectedData, "Expected cached image data to match", file: file, line: line)
                } else {
                    XCTFail("Could not find feed image with id \(image.id)", file: file, line: line)
                }
                exp.fulfill()
            } catch {
                XCTFail("Failed to verify cached image data: \(error)", file: file, line: line)
                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1.0)
    }
}

extension CoreDataFeedStore.ModelNotFound: @retroactive CustomStringConvertible {
    public var description: String {
        "Core Data Model '\(modelName).xcdatamodeld' not found. You need to create it in the production target."
    }
}
