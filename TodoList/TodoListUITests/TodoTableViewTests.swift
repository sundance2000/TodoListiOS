//
//  TodoTableViewTests.swift
//  TodoListUITests
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import XCTest

class TodoTableViewTests: XCTestCase {

    private let app = XCUIApplication()
    private var addButton: XCUIElement!
    private var backButton: XCUIElement!
    private var cancelButton: XCUIElement!
    private var saveButton: XCUIElement!
    private var titleTextField: XCUIElement!
    private var dueDateLabel: XCUIElement!
    private var descriptionTextField: XCUIElement!
    private var doneSwitch: XCUIElement!

    static private var simpledateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()

    override func setUp() {
        self.initialize()

        self.addButton = self.app.navigationBars["Todos"].buttons["Add"]
        self.backButton = self.app.navigationBars["Todo"].buttons["Todos"]
        self.cancelButton = self.app.navigationBars["Todo"].buttons["Cancel"]
        self.saveButton = self.app.navigationBars["Todo"].buttons["Save"]
        self.titleTextField = self.app.tables.textFields.element(boundBy: 0)
        self.dueDateLabel = self.app.staticTexts[TodoTableViewTests.simpledateFormatter.string(from: Date())]
        self.descriptionTextField = self.app.tables.textFields.element(boundBy: 1)
        self.doneSwitch = self.app.switches.firstMatch

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

    private func deleteFirst() {
        self.app.tables.cells.element(boundBy: 0).swipeLeft()
        self.app.tables.cells.element(boundBy: 0).buttons["Delete"].tap()
    }

    private func deleteAll() {
        for _ in 0..<self.app.tables.cells.count {
            self.app.tables.cells.element(boundBy: 0).swipeLeft()
            self.app.tables.cells.element(boundBy: 0).buttons["Delete"].tap()
        }
    }

    private func initialize() {
        XCUIApplication().launch()
        self.app.navigationBars["Todos"].children(matching: .button).element(boundBy: 0).tap()
        let serverAddressTextField = self.app.tables.textFields.firstMatch
        if serverAddressTextField.value as! String != "https://todo-list-integration-test.herokuapp.com" {
            self.app.tables.children(matching: .cell).element(boundBy: 0).buttons["Clear text"].tap()
            serverAddressTextField.tap()
            serverAddressTextField.typeText("https://todo-list-integration-test.herokuapp.com")
            self.app.navigationBars["Settings"].buttons["Done"].tap()
            // Give integration test server some time to start
            sleep(60)
        }

        XCUIApplication().terminate()
    }

    // MARK: - Create

    func testCreateTodo() {
        // 1. Arrange
        self.addButton.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("A")
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("1")
        self.doneSwitch.tap()
        self.saveButton.tap()

        // 3. Assert
        self.app.tables.cells.firstMatch.tap()
        XCTAssertEqual(self.titleTextField.value as! String, "A")
        XCTAssertTrue(self.dueDateLabel.exists)
        XCTAssertEqual(self.descriptionTextField.value as! String, "1")
        XCTAssertEqual(self.doneSwitch.value as! String, "1")
    }

    func testCreateTodoMissingDescription() {
        // 1. Arrange
        self.addButton.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("A")
        self.doneSwitch.tap()
        self.saveButton.tap()

        // 3. Assert
        self.app.tables.cells.firstMatch.tap()
        XCTAssertEqual(self.titleTextField.value as! String, "A")
        XCTAssertTrue(self.dueDateLabel.exists)
        XCTAssertEqual(self.descriptionTextField.value as! String, "Description")
        XCTAssertEqual(self.doneSwitch.value as! String, "1")
    }

    func testCreateTodoMissingTitle() {
        // 1. Arrange
        self.addButton.tap()
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("1")
        self.doneSwitch.tap()

        // 3. Assert
        XCTAssertFalse(self.saveButton.isEnabled)
    }

    func testCreateTodoTitleTooShort() {
        // 1. Arrange
        self.addButton.tap()
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("")
        self.doneSwitch.tap()

        // 3. Assert
        XCTAssertFalse(self.saveButton.isEnabled)
    }

    func testCreateTodoTitleTooLong() {
        // 1. Arrange
        self.addButton.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("1234567890123456789012345678901")
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("1")
        self.doneSwitch.tap()
        self.saveButton.tap()

        // 3. Assert
        self.app.tables.cells.firstMatch.tap()
        XCTAssertEqual(self.titleTextField.value as! String, "123456789012345678901234567890")
        XCTAssertTrue(self.dueDateLabel.exists)
        XCTAssertEqual(self.descriptionTextField.value as! String, "1")
        XCTAssertEqual(self.doneSwitch.value as! String, "1")
    }

    // MARK: - Update

    func testUpdateTodo() {
        // 1. Arrange
        self.addButton.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("A")
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("1")
        self.doneSwitch.tap()
        self.saveButton.tap()

        // 2. Action
        self.app.tables.cells.firstMatch.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("B")
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("2")
        self.doneSwitch.tap()
        self.backButton.tap()

        // 3. Assert
        self.app.tables.cells.firstMatch.tap()
        XCTAssertEqual(self.titleTextField.value as! String, "AB")
        XCTAssertTrue(self.dueDateLabel.exists)
        XCTAssertEqual(self.descriptionTextField.value as! String, "12")
        XCTAssertEqual(self.doneSwitch.value as! String, "0")
    }

    func testUpdateTodoClearDescription() {
        // 1. Arrange
        self.addButton.tap()
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("1")
        self.titleTextField.tap()
        self.titleTextField.typeText("A")
        self.doneSwitch.tap()
        self.saveButton.tap()

        // 2. Action
        self.app.tables.cells.firstMatch.tap()
        self.app.tables.children(matching: .cell).element(boundBy: 2).buttons.firstMatch.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("B")
        self.doneSwitch.tap()
        self.backButton.tap()

        // 3. Assert
        self.app.tables.cells.firstMatch.tap()
        XCTAssertEqual(self.titleTextField.value as! String, "AB")
        XCTAssertTrue(self.dueDateLabel.exists)
        XCTAssertEqual(self.descriptionTextField.value as! String, "Description")
        XCTAssertEqual(self.doneSwitch.value as! String, "0")
    }

    func testUpdateTodoClearTitle() {
        // 1. Arrange
        self.addButton.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("A")
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("1")
        self.doneSwitch.tap()
        self.saveButton.tap()

        // 2. Action
        self.app.tables.cells.firstMatch.tap()
        self.app.tables.children(matching: .cell).element(boundBy: 0).buttons["Clear text"].tap()
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("2")
        self.doneSwitch.tap()
        self.backButton.tap()

        // 3. Assert
        self.app.tables.cells.firstMatch.tap()
        XCTAssertEqual(self.titleTextField.value as! String, "A")
        XCTAssertTrue(self.dueDateLabel.exists)
        XCTAssertEqual(self.descriptionTextField.value as! String, "1")
        XCTAssertEqual(self.doneSwitch.value as! String, "1")
    }

    func testUpdateTodoTitleTooLong() {
        // 1. Arrange
        self.addButton.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("1")
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("1")
        self.doneSwitch.tap()
        self.saveButton.tap()

        // 2. Action
        self.app.tables.cells.firstMatch.tap()
        self.titleTextField.tap()
        self.titleTextField.typeText("234567890123456789012345678901")
        self.descriptionTextField.tap()
        self.descriptionTextField.typeText("2")
        self.doneSwitch.tap()
        self.backButton.tap()

        // 3. Assert
        self.app.tables.cells.firstMatch.tap()
        XCTAssertEqual(self.titleTextField.value as! String, "123456789012345678901234567890")
        XCTAssertTrue(self.dueDateLabel.exists)
        XCTAssertEqual(self.descriptionTextField.value as! String, "12")
        XCTAssertEqual(self.doneSwitch.value as! String, "0")
    }

}
