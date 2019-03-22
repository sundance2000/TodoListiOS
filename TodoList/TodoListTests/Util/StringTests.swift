//
//  StringTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 22.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import XCTest

class StringTests: XCTestCase {

    func testRfc3339Date() {
        // 1. Arrange
        let date = Date(timeIntervalSince1970: 1551443696)
        let string = "2019-03-01T12:34:56.000Z"

        // 3. Assert
        XCTAssertEqual(string.rfc3339date, date)
    }

    func testRfc3339DateWithFractionalSeconds() {
        // 1. Arrange
        let date = Date(timeIntervalSince1970: 1551443696.789)
        let string = "2019-03-01T12:34:56.789Z"

        // 3. Assert
        XCTAssertEqual(string.rfc3339date, date)
    }

    func testRfc3339DateWithoutFractionalSeconds() {
        // 1. Arrange
        let date = Date(timeIntervalSince1970: 1551443696)
        let string = "2019-03-01T12:34:56Z"

        // 3. Assert
        XCTAssertEqual(string.rfc3339date, date)
    }


}
