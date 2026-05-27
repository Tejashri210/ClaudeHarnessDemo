import XCTest
import FeedFeature
@testable import FeedUI

final class FeedViewControllerTest: XCTestCase {

    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCount, 0, "Expected no loading requests before view is loaded")
        sut.simulateAppearance()
        XCTAssertEqual(loader.loadCount, 1, "Expected a loading request once view is loaded")
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCount, 2, "Expected another loading request once user initiates a reload")
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCount, 3, "Expected yet another loading request once user initiates another reload")
    }

    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        loader.completeLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        loader.completeLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed with success")
        sut.simulateUserInitiatedReload()
        loader.completeLoadingWithError(at: 2)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed with failure")
    }

    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let (sut, loader) = makeSUT()
        let feed0 = makeFeedItem(description: "description1", location: "Barcelona")
        let feed1 = makeFeedItem(description: "description2", location: "Singapore")
        let feed2 = makeFeedItem(description: "description3")
        let feed3 = makeFeedItem(location: "Amsterdam")

        sut.simulateAppearance()
        assertThat(sut, isRendering: [])

        loader.completeLoading(with: [feed0], at: 0)
        assertThat(sut, isRendering: [feed0])

        sut.simulateUserInitiatedReload()
        loader.completeLoading(with: [feed0, feed1, feed2, feed3], at: 0)
        assertThat(sut, isRendering: [feed0, feed1, feed2, feed3])
    }

    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let feed0 = makeFeedItem(description: "description1", location: "Barcelona")
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0], at: 0)
        assertThat(sut, isRendering: [feed0])

        sut.simulateUserInitiatedReload()
        loader.completeLoadingWithError(at: 1)
        assertThat(sut, isRendering: [feed0])
    }

    func test_feedImageView_loadsImageURLWhenVisible() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0, feed1], at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        let _ = sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [feed0.imageURL], "Expected first image URL request once first view becomes visible")

        let _ = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [feed0.imageURL, feed1.imageURL], "Expected second image URL request once second view also becomes visible")
    }

    func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0, feed1], at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")

        sut.simulateFeedImageViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [feed0.imageURL], "Expected one cancelled image URL request once first image is not visible anymore")

        sut.simulateFeedImageViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [feed0.imageURL, feed1.imageURL], "Expected two cancelled image URL requests once second image is also not visible anymore")
    }

    func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0, feed1], at: 0)

        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")

        let imageData0 = UIImage.make(withColor: .red).normalized()?.pngData()
        loader.completeImageLoading(with: imageData0!, at: 0)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")

        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")
    }

    func test_feedImageView_rendersImageLoadedFromURL() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0, feed1], at: 0)

        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")

        let imageData0 = UIImage.make(withColor: .red).normalized()?.pngData()
        loader.completeImageLoading(with: imageData0!, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for second view once first image loading completes successfully")

        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for first view once second image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for second view once second image loading completes successfully")
    }

    func test_feedImageViewRetryButton_isVisibleOnImageURLLoadError() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0, feed1], at: 0)

        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first image")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view while loading second image")

        let imageData = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData, at: 0)

        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second image loading completes with error")
    }

    func test_feedImageViewRetryButton_isVisibleOnInvalidImageData() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0, feed1], at: 0)
        let view0 = sut.simulateFeedImageViewVisible(at: 0)

        let imageData = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData, at: 0)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action while loading image")

        let invalidImageData = Data("invalid image data".utf8)
        loader.completeImageLoading(with: invalidImageData, at: 0)
        XCTAssertEqual(view0?.isShowingRetryAction, true, "Expected retry action once image loading completes with invalid image data")
    }

    func test_feedImageViewRetryAction_retriesImageLoad() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0, feed1], at: 0)

        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)

        XCTAssertEqual(loader.loadedImageURLs, [feed0.imageURL, feed1.imageURL], "Expected two image URL request for the two visible views")

        loader.completeImageLoadingWithError(at: 0)
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [feed0.imageURL, feed1.imageURL], "Expected only two image URL requests before retry action")

        view0?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [feed0.imageURL, feed1.imageURL, feed0.imageURL], "Expected third imageURL request after first view retry action")

        view1?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [feed0.imageURL, feed1.imageURL, feed0.imageURL, feed1.imageURL], "Expected fourth imageURL request after second view retry action")
    }

    func test_feedImageView_preloadsImageURLWhenNearVisible() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()

        loader.completeLoading(with: [feed0, feed1], at: 0)

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")

        sut.simulateFeedImageViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [feed0.imageURL], "Expected first image URL request once first image is near visible")

        sut.simulateFeedImageViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [feed0.imageURL, feed1.imageURL], "Expected second image URL request once second image is near visible")
    }

    func test_feedImageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let feed0 = makeFeedItem(imageUrl: URL(string: "http://url-0.com")!)
        let feed1 = makeFeedItem(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        loader.completeLoading(with: [feed0], at: 0)

        let feedCell = sut.simulateFeedImageViewNotVisible(at: 0)
        loader.completeLoading(with: [feed1], at: 0)

        XCTAssertNil(feedCell?.renderedImage, "Expected no rendered image when an image load finishes after the view is not visible anymore")
    }
}

// MARK: - Factory
extension FeedViewControllerTest {

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: FeedLoaderSpy) {
        let loader = FeedLoaderSpy()
        let sut = FeedUIComposer.feedComposedWith(feedLoader: loader, imageLoader: loader)
        sut.setFakeRefreshControl()
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    func makeFeedItem(description: String? = nil,
                      location: String? = nil,
                      imageUrl: URL = URL(string: "https://any-url.com")!) -> FeedItem {
        return FeedItem(id: UUID(),
                        description: description,
                        location: location,
                        imageURL: imageUrl)
    }
}
