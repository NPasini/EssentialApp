//
//  Localized.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import Foundation

public final class Localized {
    static var bundle: Bundle { .module }
}

public extension Localized {
    enum Feed {
        static var table: String { "Feed" }

        public static var title: String {
            NSLocalizedString(
                "FEED_VIEW_TITLE",
                tableName: table,
                bundle: bundle,
                comment: "Title for the feed view")
        }
    }
}

public extension Localized {
    enum Shared {
        static var table: String { "Shared" }

        public static var loadError: String {
            NSLocalizedString(
                "GENERIC_CONNECTION_ERROR",
                tableName: table,
                bundle: bundle,
                comment: "Error message displayed when we can't load a resource from the server")
        }
    }
}
