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
    
    func test_map_createsViewModels() {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        
        let comments = [
            ImageComment(
                id: UUID(),
                message: "a message",
                createdAt: now.adding(minutes: -5),
                username: "a username"),
            ImageComment(
                id: UUID(),
                message: "another message",
                createdAt: now.adding(days: -1),
                username: "another username")
        ]
        
        let viewModel = ImageCommentsPresenter.map(
            comments,
            currentDate: now,
            calendar: calendar,
            locale: locale
        )
        
        XCTAssertEqual(viewModel.comments, [
            ImageCommentViewModel(
                date: "5 minutes ago",
                message: "a message",
                username: "a username"
            ),
            ImageCommentViewModel(
                date: "1 day ago",
                message: "another message",
                username: "another username"
            )
        ])
    }
}
