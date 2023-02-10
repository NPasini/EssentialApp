//
//  FeedViewControllerTests+Localization.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import XCTest
import iOSUtilities

extension FeedUIIntegrationTests {
    
    var loadError: String {
        Localized.Shared.loadError
    }
    
    var feedTitle: String {
        Localized.Feed.title
    }
    
    var commentsTitle: String {
        Localized.ImageComments.title
    }
}
