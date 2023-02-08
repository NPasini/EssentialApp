//
//  FeedImagePresenterTests.swift
//  
//
//  Created by Nicolò Pasini on 24/07/22.
//

import XCTest
import EssentialFeed
import TestUtilities

class FeedImagePresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.location, image.location)
        XCTAssertEqual(viewModel.description, image.description)
    }
}
