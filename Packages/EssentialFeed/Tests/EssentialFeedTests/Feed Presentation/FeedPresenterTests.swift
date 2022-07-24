//
//  FeedPresenterTests.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import XCTest
import EssentialFeed

final class FeedPresenter {

    private let view: Any

    init(view: Any) {
        self.view = view
    }
}

class FeedPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        let _ = FeedPresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty, "Expect no view messages")
    }

    // MARK: - Helper Methods

    private class ViewSpy {
        let messages = [Any]()
    }
}
