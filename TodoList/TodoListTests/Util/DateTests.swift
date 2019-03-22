//
//  DateTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 22.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import XCTest

class DateTests: XCTestCase {

    func testRfc3339String() {
        // 1. Arrange
        let date = Date(timeIntervalSince1970: 1551443696)
        let string = "2019-03-01T12:34:56.000Z"

        // 3. Assert
        XCTAssertEqual(date.rfc3339String, string)
    }

    func testRfc3339StringWithFractionalSeconds() {
        // 1. Arrange
        let date = Date(timeIntervalSince1970: 1551443696.789)
        let string = "2019-03-01T12:34:56.789Z"

        // 3. Assert
        XCTAssertEqual(date.rfc3339String, string)
    }

}
