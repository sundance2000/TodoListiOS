//
//  TodoFullTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import XCTest

class TodoFullTests: XCTestCase {

    func testJsonEncode() {
        // 1. Arrange
        let todoFull = TodoFull(id: 1, desc: "test", done: false, dueDate: "2019-03-17T16:06:38.445Z", title: "test")
        let todoFullJsonString = "{\"done\":false,\"id\":1,\"title\":\"test\",\"description\":\"test\",\"dueDate\":\"2019-03-17T16:06:38.445Z\"}"

        // 2. Action
        let todoFullJsonData = (try? JSONEncoder().encode(todoFull))!

        // 3. Assert
        XCTAssertEqual(String(data: todoFullJsonData, encoding: .utf8), todoFullJsonString)
    }

    func testJsonDecode() {
        // 1. Arrange
        let todoFull = TodoFull(id: 1, desc: "test", done: false, dueDate: "2019-03-17T16:06:38.445Z", title: "test")
        let todoFullJsonString = "{\"done\":false,\"id\":1,\"title\":\"test\",\"description\":\"test\",\"dueDate\":\"2019-03-17T16:06:38.445Z\"}"

        // 2. Action
        let todoFullJsonData = todoFullJsonString.data(using: .utf8)!

        // 3. Assert
        XCTAssertEqual(try? JSONDecoder().decode(TodoFull.self, from: todoFullJsonData), todoFull)
    }

}
