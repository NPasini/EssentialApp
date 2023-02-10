//
//  FeedLocalizationTests.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import XCTest
import iOSUtilities
import TestUtilities

final class FeedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = iOSUtilitiesPackageBundle
        
        assertLocalizedKeyAndValueExists(in: bundle, table)
    }
}
