//
//  ImageCommentsLocalizationTests.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import XCTest
import iOSUtilities
import TestUtilities

final class ImageCommentsLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = iOSUtilitiesPackageBundle
        
        assertLocalizedKeyAndValueExists(in: bundle, table)
    }
}
