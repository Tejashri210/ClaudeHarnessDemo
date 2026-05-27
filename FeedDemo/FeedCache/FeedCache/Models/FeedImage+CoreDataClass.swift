import Foundation
import CoreData

@objc(FeedImage)
class FeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: Cache

    static func images(from feed: [LocalFeedImage],
                       in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: feed.map { local in
            let managed = FeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            return managed
        })
    }

    var local: LocalFeedImage {
        return LocalFeedImage(id: id,
                              description: imageDescription,
                              location: location,
                              url: url)
    }
}
