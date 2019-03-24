//
//  AppCoordinatorTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 24.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import XCTest

class AppCoordinatorTests: XCTestCase {

    func testRootViewController() {
        // 3. Assert
        XCTAssertTrue(AppCoordinator(window: UIWindow(frame: UIScreen.main.bounds)).rootViewController is UINavigationController)
    }

    func testStart() {
        // 1. Arrange
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appCoordinator = AppCoordinator(window: window)

        // 2. Action
        appCoordinator.start()

        // 3. Assert
        XCTAssertEqual(window.rootViewController, appCoordinator.rootViewController)
    }

}
