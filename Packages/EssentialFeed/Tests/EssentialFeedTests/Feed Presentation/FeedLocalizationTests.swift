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
        let presentationBundle = iOSUtilitiesPackageBundle
        let localizationBundles = allLocalizationBundles(in: presentationBundle)
        let localizedStringKeys = allLocalizedStringKeys(in: localizationBundles, table: table)

        localizationBundles.forEach { (bundle, localization) in
            localizedStringKeys.forEach { key in
                let localizedString = bundle.localizedString(forKey: key, value: nil, table: table)

                if localizedString == key {
                    let language = Locale.current.localizedString(forLanguageCode: localization) ?? ""

                    XCTFail("Missing \(language) (\(localization)) localized string for key: '\(key)' in table: '\(table)'")
                }
            }
        }
    }
}
