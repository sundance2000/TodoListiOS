//
//  TodosTableViewControllerTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 24.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import CoreStore
import Cuckoo
import XCTest

class TodosTableViewControllerTests: XCTestCase {

    override func setUp() {
        self.deleteAll()
    }

    override func tearDown() {
        self.deleteAll()
    }

    private func create(id: Int32, dueDate: Date) {
        let todoFull = TodoFull(id: id, desc: "description", done: false, dueDate: dueDate.rfc3339String, title: "test")
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

    // MARK: - Table view data source

    func testNumberOfSections() {
        // 1. Arrange
        self.create(id: 1, dueDate: Date())
        self.create(id: 2, dueDate: Date())
        self.create(id: 3, dueDate: Date())
        let todosTableViewController = TodosTableViewController()

        // 3. Assert
        XCTAssertEqual(todosTableViewController.numberOfSections(in: todosTableViewController.tableView), 1)
    }

    func testNumberOfSectionsEmpty() {
        // 1. Arrange
        let todosTableViewController = TodosTableViewController()

        // 3. Assert
        XCTAssertEqual(todosTableViewController.numberOfSections(in: todosTableViewController.tableView), 0)
    }

    func testNumberOfRowsInSection() {
        // 1. Arrange
        self.create(id: 1, dueDate: Date())
        self.create(id: 2, dueDate: Date())
        self.create(id: 3, dueDate: Date())

        let todosTableViewController = TodosTableViewController()

        // 3. Assert
        XCTAssertEqual(todosTableViewController.tableView(todosTableViewController.tableView, numberOfRowsInSection: 0), 3)
    }

    func testCellForRowAt() {
        // 1. Arrange
        self.create(id: 1, dueDate: Date())
        let todo = self.get(1)
        let todosTableViewController = TodosTableViewController()

        // 2.Actions
        let cell = todosTableViewController.tableView(todosTableViewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! TodoTableViewCell

        // 3. Assert
        XCTAssertFalse(cell.doneSwitch.on)
        XCTAssertEqual(cell.titleLabel.text, todo?.title)
        XCTAssertEqual(cell.todo, todo)
    }

    func testTitleForHeaderInSectionYesterday() {
        // 1. Arrange
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        self.create(id: 1, dueDate: date)
        let todosTableViewController = TodosTableViewController()

        // 3. Assert
        XCTAssertEqual(todosTableViewController.tableView(todosTableViewController.tableView, titleForHeaderInSection: 0), Texts.yesterday)
    }

    func testTitleForHeaderInSectionToday() {
        // 1. Arrange
        self.create(id: 1, dueDate: Date())
        let todosTableViewController = TodosTableViewController()

        // 3. Assert
        XCTAssertEqual(todosTableViewController.tableView(todosTableViewController.tableView, titleForHeaderInSection: 0), Texts.today)
    }

    func testTitleForHeaderInSectionTomorow() {
        // 1. Arrange
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        self.create(id: 1, dueDate: date)
        let todosTableViewController = TodosTableViewController()

        // 3. Assert
        XCTAssertEqual(todosTableViewController.tableView(todosTableViewController.tableView, titleForHeaderInSection: 0), Texts.tomorrow)
    }

    func testTitleForHeaderInSectionOneWeek() {
        // 1. Arrange
        let date = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        self.create(id: 1, dueDate: date)
        let todosTableViewController = TodosTableViewController()

        // 3. Assert
        XCTAssertEqual(todosTableViewController.tableView(todosTableViewController.tableView, titleForHeaderInSection: 0), date.dayString)
    }

    func testDidSelectRow() {
        // 1. Arrange
        self.create(id: 1, dueDate: Date())
        let todosTableViewController = TodosTableViewController()
        let todosTableViewControllerDelegate = MockTodosTableViewControllerDelegate()
        stub(todosTableViewControllerDelegate) { todosTableViewControllerDelegate in
            when(todosTableViewControllerDelegate).select(any()).thenDoNothing()
        }
        todosTableViewController.delegate = todosTableViewControllerDelegate

        // 2.Actions
        todosTableViewController.tableView(todosTableViewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        // 3. Assert
        verify(todosTableViewControllerDelegate).select(equal(to: self.get(1)!))
        verifyNoMoreInteractions(todosTableViewControllerDelegate)
    }

    func testEditingStyleForRowAt() {
        // 1. Arrange
        let todosTableViewController = TodosTableViewController()

        // 3. Assert
        XCTAssertEqual(todosTableViewController.tableView(todosTableViewController.tableView, editingStyleForRowAt: IndexPath(row: 0, section: 0)), .delete)
    }

    func testCommitEditingStyle() {
        // 1. Arrange
        self.create(id: 1, dueDate: Date())
        let todosTableViewController = TodosTableViewController()
        let todosTableViewControllerDelegate = MockTodosTableViewControllerDelegate()
        stub(todosTableViewControllerDelegate) { todosTableViewControllerDelegate in
            when(todosTableViewControllerDelegate).delete(any()).thenDoNothing()
        }
        todosTableViewController.delegate = todosTableViewControllerDelegate

        // 2.Actions
        todosTableViewController.tableView(todosTableViewController.tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))

        // 3. Assert
        verify(todosTableViewControllerDelegate).delete(equal(to: self.get(1)!))
        verifyNoMoreInteractions(todosTableViewControllerDelegate)
    }

    // MARK: - Navigation

    func testAdd() {
        // 1. Arrange
        self.create(id: 1, dueDate: Date())
        let todosTableViewController = TodosTableViewController()
        let todosTableViewControllerDelegate = MockTodosTableViewControllerDelegate()
        stub(todosTableViewControllerDelegate) { todosTableViewControllerDelegate in
            when(todosTableViewControllerDelegate).add().thenDoNothing()
        }
        todosTableViewController.delegate = todosTableViewControllerDelegate

        // 2.Actions
        todosTableViewController.add()

        // 3. Assert
        verify(todosTableViewControllerDelegate).add()
        verifyNoMoreInteractions(todosTableViewControllerDelegate)
    }

    func testShowSettings() {
        // 1. Arrange
        self.create(id: 1, dueDate: Date())
        let todosTableViewController = TodosTableViewController()
        let todosTableViewControllerDelegate = MockTodosTableViewControllerDelegate()
        stub(todosTableViewControllerDelegate) { todosTableViewControllerDelegate in
            when(todosTableViewControllerDelegate).showSettings().thenDoNothing()
        }
        todosTableViewController.delegate = todosTableViewControllerDelegate

        // 2.Actions
        todosTableViewController.showSettings()

        // 3. Assert
        verify(todosTableViewControllerDelegate).showSettings()
        verifyNoMoreInteractions(todosTableViewControllerDelegate)
    }

}
