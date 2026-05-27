import UIKit
import FeedFeature
import FeedNetwork
import FeedUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let feedURL = URL(string: "http://localhost:3000/feeds")!
        let httpClient = URLSessionHTTPClient()
        let feedLoader = RemoteFeedLoader(url: feedURL, client: httpClient)
        let imageLoader = RemoteImageDataLoader()

        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: feedLoader,
            imageLoader: imageLoader
        )

        let navigation = UINavigationController(rootViewController: feedViewController)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
