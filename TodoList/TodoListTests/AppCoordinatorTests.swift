//
//  AppCoordinatorTests.swift
//  TodoListTests
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

@testable import TodoList
import XCTest

class AppCoordinatorTests: XCTestCase {

    func testRootViewController() {
        // 3. Assert
        XCTAssertTrue(AppCoordinator(window: UIWindow(frame: UIScreen.main.bounds)).rootViewController is UIViewController)
    }

}
