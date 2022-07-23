//
//  FeedViewControllerTests+Localization.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import XCTest
import Foundation
import iOSUtilities

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = iOSUtilitiesPackageBundle
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
