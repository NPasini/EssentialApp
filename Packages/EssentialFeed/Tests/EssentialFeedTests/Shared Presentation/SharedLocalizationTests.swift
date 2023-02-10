//
//  SharedLocalizationTests.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import XCTest
import iOSUtilities
import TestUtilities

class SharedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = iOSUtilitiesPackageBundle
        
        assertLocalizedKeyAndValueExists(in: bundle, table)
    }
}
