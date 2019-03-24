//
//  TodoRepositoryTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 24.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import CoreStore
import XCTest

class TodoRepositoryTests: XCTestCase {

    override func setUp() {
        self.deleteAll()
    }

    override func tearDown() {
        self.deleteAll()
    }

    private func create(_ id: Int32) {
        let todoFull = TodoFull(id: id, desc: "description", done: false, dueDate: "2019-03-17T16:06:38.445Z", title: "test")
        let saveExpectation = self.expectation(description: "create")
        TodoRepository.shared.save(todoFull) {
            saveExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    private func deleteAll() {
        let deleteExpectation = self.expectation(description: "deleteAll")
        Database.dataStack.perform(asynchronous: { transaction in
            transaction.deleteAll(From<Todo>())
        }, completion: { _ in
            deleteExpectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }

    private func get(_ id: Int32) -> Todo? {
        return Database.dataStack.fetchOne(From<Todo>().where(\.id == id))
    }

    func testDeleteTodo() {
        // 1. Arrange
        self.create(1)
        guard let todo = self.get(1) else {
            XCTFail("Cannot get todo")
            return
        }

        // 2. Action
        let deleteExpectation = self.expectation(description: "delete")
        TodoRepository.shared.delete(todo) {
            deleteExpectation.fulfill()
        }

        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(self.get(1))
    }

    func testDeleteTodoTwice() {
        // 1. Arrange
        self.create(1)
        guard let todo = self.get(1) else {
            XCTFail("Cannot get todo")
            return
        }

        // 2. Action
        let deleteExpectation = self.expectation(description: "delete")
        TodoRepository.shared.delete(todo) {
            deleteExpectation.fulfill()
        }
        let deleteExpectation2 = self.expectation(description: "delete2")
        TodoRepository.shared.delete(todo) {
            deleteExpectation2.fulfill()
        }

        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(self.get(1))
    }

    func testDeleteIds() {
        // 1. Arrange
        self.create(1)
        self.create(2)

        // 2. Action
        let deleteExpectation = self.expectation(description: "delete")
        TodoRepository.shared.delete([1, 2]) {
            deleteExpectation.fulfill()
        }

        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(self.get(1))
        XCTAssertNil(self.get(1))
    }

    func testSave() {
        // 2. Action
        self.create(1)

        // 3. Assert
        let todo = self.get(1)
        XCTAssertNotNil(todo)
        XCTAssertEqual(todo?.id, 1)
        XCTAssertEqual(todo?.desc, "description")
        XCTAssertEqual(todo?.done, false)
        XCTAssertEqual(todo?.dueDate, "2019-03-17T16:06:38.445Z".rfc3339date)
        XCTAssertEqual(todo?.dueDay, "2019-03-17T16:06:38.445Z".rfc3339date?.dayString.dayDate)
        XCTAssertEqual(todo?.title, "test")
    }

    func testSaveInvalidTodoFull() {
        // 1. Arrange
        let todoFull = TodoFull(id: 1, desc: "test", done: false, dueDate: "2019-03-17T16:06:38.445Z", title: nil)
        let saveExpectation = self.expectation(description: "save")

        // 2. Action
        TodoRepository.shared.save(todoFull) {
            saveExpectation.fulfill()
        }
        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(self.get(1))
    }

    func testSaveTodoList() {
        // 1. Arrange
        let todoList1 = TodoList(id: 1, done: false, dueDate: "2019-03-17T16:06:38.441Z", title: "test1")
        let todoList2 = TodoList(id: 2, done: true, dueDate: "2019-03-17T16:06:38.442Z", title: "test2")
        let saveExpectation = self.expectation(description: "save")

        // 2. Action
        TodoRepository.shared.save([todoList1, todoList2]) {
            saveExpectation.fulfill()
        }
        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        let todo1 = self.get(1)
        XCTAssertNotNil(todo1)
        XCTAssertEqual(todo1?.id, 1)
        XCTAssertNil(todo1?.desc)
        XCTAssertEqual(todo1?.done, false)
        XCTAssertEqual(todo1?.dueDate, "2019-03-17T16:06:38.441Z".rfc3339date)
        XCTAssertEqual(todo1?.dueDay, "2019-03-17T16:06:38.441Z".rfc3339date?.dayString.dayDate)
        XCTAssertEqual(todo1?.title, "test1")
        let todo2 = self.get(2)
        XCTAssertNotNil(todo2)
        XCTAssertEqual(todo2?.id, 2)
        XCTAssertNil(todo2?.desc)
        XCTAssertEqual(todo2?.done, true)
        XCTAssertEqual(todo2?.dueDate, "2019-03-17T16:06:38.442Z".rfc3339date)
        XCTAssertEqual(todo2?.dueDay, "2019-03-17T16:06:38.442Z".rfc3339date?.dayString.dayDate)
        XCTAssertEqual(todo2?.title, "test2")
    }

    func testSaveTodoListInvalidTodoList() {
        // 1. Arrange
        let todoList1 = TodoList(id: 1, done: false, dueDate: "2019-03-17T16:06:38.445Z", title: nil)
        let todoList2 = TodoList(id: 2, done: true, dueDate: "2019-03-17T16:06:38.442Z", title: "test2")
        let saveExpectation = self.expectation(description: "save")

        // 2. Action
        TodoRepository.shared.save([todoList1, todoList2]) {
            saveExpectation.fulfill()
        }
        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(self.get(1))
        let todo2 = self.get(2)
        XCTAssertNotNil(todo2)
        XCTAssertEqual(todo2?.id, 2)
        XCTAssertNil(todo2?.desc)
        XCTAssertEqual(todo2?.done, true)
        XCTAssertEqual(todo2?.dueDate, "2019-03-17T16:06:38.442Z".rfc3339date)
        XCTAssertEqual(todo2?.dueDay, "2019-03-17T16:06:38.442Z".rfc3339date?.dayString.dayDate)
        XCTAssertEqual(todo2?.title, "test2")
    }

    func testSaveTodoListOverwite() {
        // 1. Arrange
        self.create(1)
        self.create(2)
        self.create(3)
        let todoList2 = TodoList(id: 2, done: true, dueDate: "2019-03-17T16:06:38.442Z", title: "test2")
        let saveExpectation = self.expectation(description: "save")

        // 2. Action
        TodoRepository.shared.save([todoList2]) {
            saveExpectation.fulfill()
        }
        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(self.get(1))
        let todo2 = self.get(2)
        XCTAssertNotNil(todo2)
        XCTAssertEqual(todo2?.id, 2)
        XCTAssertEqual(todo2?.desc, "description")
        XCTAssertEqual(todo2?.done, true)
        XCTAssertEqual(todo2?.dueDate, "2019-03-17T16:06:38.442Z".rfc3339date)
        XCTAssertEqual(todo2?.dueDay, "2019-03-17T16:06:38.442Z".rfc3339date?.dayString.dayDate)
        XCTAssertEqual(todo2?.title, "test2")
        XCTAssertNil(self.get(3))
    }

    func testUpdate() {
        // 1. Arrange
        self.create(1)
        guard let todo = self.get(1) else {
            XCTFail("Cannot get todo")
            return
        }
        let todoFull = TodoFull(id: 1, desc: "description2", done: true, dueDate: "2019-03-17T16:06:38.442Z", title: "test2")
        let updateExpectation = self.expectation(description: "update")

        // 2. Action
        TodoRepository.shared.update(todo, with: todoFull) { todo in
            XCTAssertNotNil(todo)
            updateExpectation.fulfill()
        }
        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        let todoGet = self.get(1)
        XCTAssertNotNil(todo)
        XCTAssertEqual(todoGet?.id, 1)
        XCTAssertEqual(todoGet?.desc, "description2")
        XCTAssertEqual(todoGet?.done, true)
        XCTAssertEqual(todoGet?.dueDate, "2019-03-17T16:06:38.442Z".rfc3339date)
        XCTAssertEqual(todoGet?.dueDay, "2019-03-17T16:06:38.442Z".rfc3339date?.dayString.dayDate)
        XCTAssertEqual(todoGet?.title, "test2")
    }

    func testUpdateTodoNotExisting() {
        // 1. Arrange
        self.create(1)
        guard let todo = self.get(1) else {
            XCTFail("Cannot get todo")
            return
        }
        let todoFull = TodoFull(id: 1, desc: "test", done: false, dueDate: "2019-03-17T16:06:38.445Z", title: "test")
        self.deleteAll()
        let updateExpectation = self.expectation(description: "update")

        // 2. Action
        TodoRepository.shared.update(todo, with: todoFull) { todo in
            XCTAssertNil(todo)
            updateExpectation.fulfill()
        }
        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(self.get(1))
    }

    func testUpdateInvalidTodoFull() {
        // 1. Arrange
        self.create(1)
        guard let todo = self.get(1) else {
            XCTFail("Cannot get todo")
            return
        }
        let todoFull = TodoFull(id: 1, desc: "test", done: false, dueDate: "2019-03-17T16:06:38.445Z", title: nil)
        let updateExpectation = self.expectation(description: "update")

        // 2. Action
        TodoRepository.shared.update(todo, with: todoFull) { todo in
            XCTAssertNotNil(todo)
            updateExpectation.fulfill()
        }
        // 3. Assert
        waitForExpectations(timeout: 5, handler: nil)
        let todoGet = self.get(1)
        XCTAssertNotNil(todo)
        XCTAssertEqual(todoGet?.id, 1)
        XCTAssertEqual(todoGet?.desc, "description")
        XCTAssertEqual(todoGet?.done, false)
        XCTAssertEqual(todoGet?.dueDate, "2019-03-17T16:06:38.445Z".rfc3339date)
        XCTAssertEqual(todoGet?.dueDay, "2019-03-17T16:06:38.445Z".rfc3339date?.dayString.dayDate)
        XCTAssertEqual(todoGet?.title, "test")
    }

}
