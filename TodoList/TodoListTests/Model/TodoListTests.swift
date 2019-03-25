//
//  TodoListTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import XCTest

class TodoLisTests: XCTestCase {

    func testJsonEncode() {
        // 1. Arrange
        let todoList = TodoList(id: 1, done: false, dueDate: "2019-03-17T16:06:38.445Z", title: "test")
        let todoListJsonString = "{\"done\":false,\"id\":1,\"title\":\"test\",\"dueDate\":\"2019-03-17T16:06:38.445Z\"}"

        // 2. Action
        let todoListJsonData = (try? JSONEncoder().encode(todoList))!

        // 3. Assert
        XCTAssertEqual(String(data: todoListJsonData, encoding: .utf8), todoListJsonString)
    }

    func testJsonDecode() {
        // 1. Arrange
        let todoList = TodoList(id: 1, done: false, dueDate: "2019-03-17T16:06:38.445Z", title: "test")
        let todoListJsonString = "{\"done\":false,\"id\":1,\"title\":\"test\",\"dueDate\":\"2019-03-17T16:06:38.445Z\"}"

        // 2. Action
        let todoListJsonData = todoListJsonString.data(using: .utf8)!

        // 3. Assert
        XCTAssertEqual(try? JSONDecoder().decode(TodoList.self, from: todoListJsonData), todoList)
    }

}
