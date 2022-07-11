//
//  NSEntityDescription+Assertions.swift
//  
//
//  Created by Nicolò Pasini on 11/07/22.
//

import XCTest
import CoreData

extension NSEntityDescription {

    func verify(attribute name: String, hasType type: NSAttributeType, isOptional: Bool, file: StaticString = #filePath, line: UInt = #line) {
        guard let attribute = attributesByName[name] else {
            XCTFail("Missing expected attribute \(name)", file: file, line: line)
            return
        }

        guard let property = propertiesByName[name] else {
            XCTFail("Missing expected property \(name)", file: file, line: line)
            return
        }

        XCTAssertEqual(attribute.attributeType, type, "attributeType", file: file, line: line)
        XCTAssertEqual(property.isOptional, isOptional, "isOptional", file: file, line: line)
    }
}
