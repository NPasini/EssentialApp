//
//  ImageCommentsPresenterTests.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import XCTest
import EssentialFeed
import TestUtilities

class ImageCommentsPresenterTests: XCTestCase {

    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE", table: "ImageComments"))
    }
}
