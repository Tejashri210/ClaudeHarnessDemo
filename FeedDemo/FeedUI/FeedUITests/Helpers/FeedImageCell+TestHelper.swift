import Foundation
@testable import FeedUI

extension FeedImageCell {

    var renderedImage: Data? {
        return feedImageView.image?.normalized()?.pngData()
    }

    var isShowingImageLoadingIndicator: Bool {
        return imageContainer.isShimmering
    }

    var isShowingRetryAction: Bool {
        return !feedImageRetryButton.isHidden
    }

    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
}
