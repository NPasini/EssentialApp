//
//  FeedPresenterTests.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import XCTest
import EssentialFeed

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

protocol FeedLoadingView: AnyObject {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedLoadingViewModel {
    let isLoading: Bool
}

struct FeedErrorViewModel {

    let errorMessage: String?

    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(errorMessage: nil)
    }
}

final class FeedPresenter {

    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView

    init(loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.errorView = errorView
        self.loadingView = loadingView
    }

    func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
}

class FeedPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expect no view messages")
    }

    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingFeed()

        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }

    // MARK: - Helper Methods

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(loadingView: view, errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy: FeedLoadingView, FeedErrorView {

        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(errorMessage: String?)
        }

        private(set) var messages = Set<Message>()

        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }

        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.errorMessage))
        }
    }
}
