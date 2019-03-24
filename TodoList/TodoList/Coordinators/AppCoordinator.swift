//
//  AppCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation
import UIKit

/**
 Coordinates handling of the app
 */
class AppCoordinator: RootViewCoordinator {

    private let window: UIWindow

    private let todosTableViewCoordinator: TodosTableViewCoordinator

    var rootViewController: UIViewController

    /**
     Constructor for AppCoordinator
     - parameter window: Window to present the application in
     */
    init(window: UIWindow) {
        self.window = window
        let navigationController = UINavigationController()
        self.todosTableViewCoordinator = TodosTableViewCoordinator(navigationController: navigationController)
        self.rootViewController = navigationController
    }

    /**
     Sets the root view controller of the window,
     starts the child coordinator
     and shows the window with the application
     */
    func start() {
        self.window.rootViewController = self.rootViewController
        self.todosTableViewCoordinator.start()
        self.window.makeKeyAndVisible()
    }

}
