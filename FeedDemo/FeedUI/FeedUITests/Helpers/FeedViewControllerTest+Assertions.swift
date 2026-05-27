import XCTest
import FeedFeature
@testable import FeedUI

extension FeedViewControllerTest {

    func assertThat(_ sut: FeedViewController, isRendering feed: [FeedItem],
                    file: StaticString = #file, line: UInt = #line) {

        XCTAssertEqual(sut.numberOfImageViewsRendered(), feed.count)
        feed.enumerated().forEach { index, feedItem in
            assertThat(sut, hasViewConfiguredFor: feedItem, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: FeedViewController, hasViewConfiguredFor feedItem: FeedItem, at index: Int,
                    file: StaticString = #file, line: UInt = #line) {

        let view = sut.feedImageView(at: index)
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead")
        }

        let shouldLocationBeVisible = (feedItem.location != nil)
        XCTAssertEqual(cell.locationContainer.isHidden, !shouldLocationBeVisible,
                       "Expected `locationContainer visibility` to be \(!shouldLocationBeVisible) for image view at index \(index)",
                       file: file, line: line)
        XCTAssertEqual(cell.locationLabel.text, feedItem.location,
                       "Expected location text to be \(String(describing: feedItem.location)) for image view at index \(index)",
                       file: file, line: line)
        XCTAssertEqual(cell.descriptionLabel.text, feedItem.description,
                       "Expected description text to be \(String(describing: feedItem.description)) for image view at index \(index)",
                       file: file, line: line)
    }
}
