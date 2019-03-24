//
//  SettingsTableViewControllerTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 24.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import Cuckoo
import XCTest

class SettingsTableViewControllerTests: XCTestCase {

    // MARK: - Table view data source

    func testNumberOfSections() {
        // 1. Arrange
        let settingsTableViewController = SettingsTableViewController()

        // 3. Assert
        XCTAssertEqual(settingsTableViewController.numberOfSections(in: settingsTableViewController.tableView), 1)
    }

    func testNumberOfRowsInSection() {
        // 1. Arrange
        let settingsTableViewController = SettingsTableViewController()

        // 3. Assert
        XCTAssertEqual(settingsTableViewController.tableView(settingsTableViewController.tableView, numberOfRowsInSection: 0), 1)
    }

    func testTitleForHeaderInSection() {
        // 1. Arrange
        let settingsTableViewController = SettingsTableViewController()

        // 3. Assert
        XCTAssertEqual(settingsTableViewController.tableView(settingsTableViewController.tableView, titleForHeaderInSection: 0), Texts.SettingsTableViewController.serverAddress)
    }

    // MARK: - Navigation

    func testGenerateSupportPackage() {
        // 1. Arrange
        let settingsTableViewController = SettingsTableViewController()
        let settingsTableViewControllerDelegate = MockSettingsTableViewControllerDelegate()
        stub(settingsTableViewControllerDelegate) { settingsTableViewControllerDelegate in
            when(settingsTableViewControllerDelegate).generateSupportPackage().thenDoNothing()
        }
        settingsTableViewController.delegate = settingsTableViewControllerDelegate

        // 2. Action
        settingsTableViewController.generateSupportPackage()

        // 3. Assert
        verify(settingsTableViewControllerDelegate).generateSupportPackage()
        verifyNoMoreInteractions(settingsTableViewControllerDelegate)
    }

    func testSave() {
        // 1. Arrange
        let settingsTableViewController = SettingsTableViewController()
        let settingsTableViewControllerDelegate = MockSettingsTableViewControllerDelegate()
        stub(settingsTableViewControllerDelegate) { settingsTableViewControllerDelegate in
            when(settingsTableViewControllerDelegate).save().thenDoNothing()
        }
        settingsTableViewController.delegate = settingsTableViewControllerDelegate

        // 2. Action
        settingsTableViewController.save()

        // 3. Assert
        verify(settingsTableViewControllerDelegate).save()
        verifyNoMoreInteractions(settingsTableViewControllerDelegate)
    }

}
