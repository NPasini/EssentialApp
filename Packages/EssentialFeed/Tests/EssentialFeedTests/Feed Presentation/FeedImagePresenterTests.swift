//
//  FeedImagePresenterTests.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import XCTest
import EssentialFeed
import TestUtilities

public protocol FeedImageView: AnyObject {
    func display(_ viewModel: FeedImageViewModel)
}

public struct FeedImageViewModel {
    let image: Any?
    let isLoading: Bool
    let location: String?
    let shouldRetry: Bool
    let description: String?

    var hasLocation: Bool { location != nil }
}

public final class FeedImagePresenter {

    private let view: FeedImageView

    public init(view: FeedImageView) {
        self.view = view
    }

    func didStartLoadingImageData(for model: FeedImage) {
        let viewModel = FeedImageViewModel(image: nil, isLoading: true, location: model.location, shouldRetry: false, description: model.description)
        view.display(viewModel)
    }
}

final class FeedImagePresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expect no view messages")
    }

    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        let image = uniqueImage()

        sut.didStartLoadingImageData(for: image)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.image)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy: FeedImageView {

        private(set) var messages = [FeedImageViewModel]()

        func display(_ viewModel: FeedImageViewModel) {
            messages.append(viewModel)
        }
    }
}
