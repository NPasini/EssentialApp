//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  
//
//  Created by Nicolò Pasini on 07/07/22.
//

import XCTest
import TestUtilities
import EssentialFeed

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().locals, Date()), to: sut)

        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }

    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().locals, Date()), to: sut)

        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}
