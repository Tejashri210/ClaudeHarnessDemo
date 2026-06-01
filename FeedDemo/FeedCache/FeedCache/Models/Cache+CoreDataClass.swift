import Foundation
import CoreData

@objc(Cache)
class Cache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet

    static func fetchCache(in context: NSManagedObjectContext) throws -> Cache? {
        let fetchRequest = NSFetchRequest<Cache>(entityName: "Cache")
        fetchRequest.returnsObjectsAsFaults = false
        let cache = try context.fetch(fetchRequest)
        return cache.first
    }

    static func fetchCachesOlderThan(_ date: Date, in context: NSManagedObjectContext) throws -> [Cache] {
        let fetchRequest = NSFetchRequest<Cache>(entityName: "Cache")
        fetchRequest.predicate = NSPredicate(format: "timestamp < %@", date as NSDate)
        fetchRequest.returnsObjectsAsFaults = false
        return try context.fetch(fetchRequest)
    }

    static func newInstance(in context: NSManagedObjectContext) throws -> Cache {
        try Cache.fetchCache(in: context).map(context.delete)
        return Cache(context: context)
    }

    var localFeedImages: [LocalFeedImage] {
        return self.feed.compactMap { ($0 as? FeedImage)?.local }
    }
}
