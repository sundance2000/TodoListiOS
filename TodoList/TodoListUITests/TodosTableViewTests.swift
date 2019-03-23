//
//  TodosTableViewTests.swift
//  TodoListUITests
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import XCTest

class TodosTableViewTests: XCTestCase {

    private let app = XCUIApplication()
    private var backButton: XCUIElement!
    private var cancelButton: XCUIElement!

    override func setUp() {
        self.backButton = self.app.navigationBars["Todo"].buttons["Back"]
        self.cancelButton = self.app.navigationBars["Todo"].buttons["Cancel"]

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        self.deleteAll()
    }

    override func tearDown() {
        if self.backButton.exists {
            self.backButton.tap()
        } else if self.cancelButton.exists {
            self.cancelButton.tap()
        }
        self.deleteAll()
    }

    private func create(_ title: String) {
        let addButton = self.app.navigationBars["TodoList.TodosTableView"].buttons["Add"]
        let saveButton = self.app.navigationBars["Todo"].buttons["Save"]
        let titleTextField = self.app.tables.textFields["Title"]
        addButton.tap()
        titleTextField.tap()
        titleTextField.typeText(title)
        saveButton.tap()
    }

    private func deleteFirst() {
        let deleteButton = self.app.tables.buttons["Delete"]
        let cell = self.app.tables.cells.firstMatch
        cell.swipeLeft()
        deleteButton.tap()
    }

    private func deleteAll() {
        let deleteButton = self.app.tables.buttons["Delete"]
        var cell = self.app.tables.cells.firstMatch
        while cell.exists {
            cell.swipeLeft()
            deleteButton.tap()
            cell = self.app.tables.cells.firstMatch
        }
    }

    func testCreateTodo() {
        // 1. Arrange
        self.create("A")

        // 3. Assert
        XCTAssertTrue(self.app.tables.cells.firstMatch.staticTexts["A"].exists)
    }

    func testGetTodosEmptyList() {
        // 3. Assert
        XCTAssertEqual(self.app.tables.cells.count, 0)
    }

    func testDeleteTodo() {
        // 1. Arrange
        self.create("A")

        // 2. Action
        self.deleteFirst()

        // 3. Assert
        XCTAssertEqual(self.app.tables.cells.count, 0)
    }

    func testGetTodos() {
        // 1. Arrange
        self.create("A")
        self.create("B")
        self.create("C")

        // 3. Assert
        XCTAssertEqual(self.app.tables.cells.count, 3)
    }

    func testToggleTodo() {
        // 1. Arrange
        let backButton = self.app.navigationBars["Todo"].buttons["Back"]
        self.create("A")

        // 2. Action
        self.app.tables.cells.children(matching: .button).element.tap()

        // 3. Assert
        self.app.tables.cells.firstMatch.tap()
        XCTAssertEqual(self.app.switches.firstMatch.value as! String, "1")

        // 4 Annihilate
        backButton.tap()
    }

    func testTodoSectionToday() {
        // 1. Arrange
        self.create("A")

        // 3. Assert
        XCTAssertTrue(self.app.tables.staticTexts["Today"].exists)
    }

}
