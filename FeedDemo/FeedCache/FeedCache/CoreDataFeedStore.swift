import CoreData

public final class CoreDataFeedStore: FeedStore {
    public static let modelName = "FeedStore"
    public static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    public struct ModelNotFound: Error {
        public let modelName: String
    }

    public init(storeURL: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw ModelNotFound(modelName: CoreDataFeedStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataFeedStore.modelName,
            model: model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }

    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                guard let cache = try Cache.fetchCache(in: context) else {
                    completion(.empty)
                    return
                }
                completion(.found(feed: cache.localFeedImages,
                                  timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                let newCache = try Cache.newInstance(in: context)
                newCache.timestamp = timestamp
                newCache.feed = FeedImage.images(from: feed, in: context)
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                try Cache.fetchCache(in: context)
                    .map(context.delete)
                    .map(context.save)
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    public func deleteCachedFeedImagesOlderThan(days: Int, completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()

                let fetchRequest = NSFetchRequest<FeedImage>(entityName: "FeedImage")
                fetchRequest.predicate = NSPredicate(format: "data != nil AND cachedAt < %@", cutoffDate as NSDate)

                let imagesToCleanup = try context.fetch(fetchRequest)

                for image in imagesToCleanup {
                    image.data = nil
                    image.cachedAt = nil
                }

                if !imagesToCleanup.isEmpty {
                    try context.save()
                }

                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    public func deleteCachedFeedImagesOlderThanSevenDays(completion: @escaping DeletionCompletion) {
        deleteCachedFeedImagesOlderThan(days: 7, completion: completion)
    }
}
