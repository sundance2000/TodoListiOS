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

    func testHttpsUrl() {
        // 1. Arrange
        let url = URL(string: "https://test.de")
        let string = "https://test.de"

        // 3. Assert
        XCTAssertEqual(string.httpsUrl, url)
    }

    func testHttpsUrlHttp() {
        // 1. Arrange
        let url = URL(string: "https://test.de")
        let string = "http://test.de"

        // 3. Assert
        XCTAssertEqual(string.httpsUrl, url)
    }

    func testHttpsUrlNoProtocol() {
        // 1. Arrange
        let url = URL(string: "https://test.de")
        let string = "test.de"

        // 3. Assert
        XCTAssertEqual(string.httpsUrl, url)
    }

    func testDayDate() {
        // 1. Arrange
        let date = Date(timeIntervalSince1970: 1551398400)
        let string = "1. 3. 2019"

        // 3. Assert
        XCTAssertEqual(string.dayDate, date)
    }

    func testDayDateWrongInput() {
        // 1. Arrange
        let string = "1. 3. 2019 00:00:00"

        // 3. Assert
        XCTAssertNil(string.dayDate)
    }

    func testLocalized() {
        // 3. Assert
        XCTAssertEqual("Cancel".localized, NSLocalizedString("Cancel", comment: ""))
    }

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

    func testRfc3339DateWrongInput() {
        // 1. Arrange
        let string = "2019-03-01T12:34:56"

        // 3. Assert
        XCTAssertNil(string.rfc3339date)
    }

}
