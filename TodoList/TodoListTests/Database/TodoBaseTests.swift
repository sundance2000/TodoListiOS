//
//  TodoBaseTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import XCTest

class TodoBaseTests: XCTestCase {

    func testJsonEncode() {
        // 1. Arrange
        let todoBase = TodoBase(desc: "test", done: false, dueDate: "2019-03-17T16:06:38.445Z", title: "test")
        let todoBaseJsonString = "{\"done\":false,\"title\":\"test\",\"description\":\"test\",\"dueDate\":\"2019-03-17T16:06:38.445Z\"}"

        // 2. Action
        let todoBaseJsonData = (try? JSONEncoder().encode(todoBase))!

        // 3. Assert
        XCTAssertEqual(String(data: todoBaseJsonData, encoding: .utf8), todoBaseJsonString)
    }

    func testJsonDecode() {
        // 1. Arrange
        let todoBase = TodoBase(desc: "test", done: false, dueDate: "2019-03-17T16:06:38.445Z", title: "test")
        let todoBaseJsonString = "{\"done\":false,\"title\":\"test\",\"description\":\"test\",\"dueDate\":\"2019-03-17T16:06:38.445Z\"}"

        // 2. Action
        let todoBaseJsonData = todoBaseJsonString.data(using: .utf8)!

        // 3. Assert
        XCTAssertEqual(try? JSONDecoder().decode(TodoBase.self, from: todoBaseJsonData), todoBase)
    }

}
