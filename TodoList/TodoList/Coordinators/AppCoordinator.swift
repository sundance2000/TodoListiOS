//
//  AppCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation
import UIKit

/// Coordinates handling of the app
class AppCoordinator: RootViewCoordinator {

    private let window: UIWindow

    private let todosTableViewCoordinator: TodosTableViewCoordinator

    var rootViewController: UIViewController

    init(window: UIWindow) {
        self.window = window
        let navigationController = UINavigationController()
        self.todosTableViewCoordinator = TodosTableViewCoordinator(navigationController: navigationController)
        self.rootViewController = navigationController
        self.window.rootViewController = self.rootViewController
    }

    func start() {
        self.todosTableViewCoordinator.start()
        self.window.makeKeyAndVisible()
    }

}
