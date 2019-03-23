//
//  TodosTableViewCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

/// Coordinates handling of todos table
class TodosTableViewCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let todosTableViewController: TodosTableViewController
    private var settingsTableViewCoordinator: SettingsTableViewCoordinator?
    private var todoTableViewCoordinator: TodoTableViewCoordinator?

    /**
     Creates a new todos table coordinator
     - parameter navigationController: The navigation controller to use
     */
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.todosTableViewController = TodosTableViewController()
        self.todosTableViewController.delegate = self
    }

    func start() {
        self.navigationController.pushViewController(self.todosTableViewController, animated: true)
    }

}

// MARK: - TodosTableViewControllerDelegate

extension TodosTableViewCoordinator: TodosTableViewControllerDelegate {

    func add() {
        // Show add todo
        self.todoTableViewCoordinator = TodoTableViewCoordinator(navigationController: self.navigationController, todo: nil)
        self.todoTableViewCoordinator?.start()
    }

    func delete(_ todo: Todo) {
        // Update database
        todo.delete() {
            // Update to server
            NetworkController.shared.delete(id: todo.id) { _ in }
        }
    }

    func select(_ todo: Todo) {
        // Update from server
        NetworkController.shared.get(id: todo.id) { _, todoFull in
            // Update database
            todo.update(todoFull) { todo in
                // Show todo
                self.todoTableViewCoordinator = TodoTableViewCoordinator(navigationController: self.navigationController, todo: todo)
                self.todoTableViewCoordinator?.start()
            }
        }
    }

    func showSettings() {
        // Show settings
        self.settingsTableViewCoordinator = SettingsTableViewCoordinator(navigationController: self.navigationController)
        self.settingsTableViewCoordinator?.start()
    }

    func toggle(_ todo: Todo) {
        let done = !todo.done
        // Update from server
        NetworkController.shared.get(id: todo.id) { _, todoFull in
            // Update database
            todo.update(todoFull) { todo  in
                todo.done = done
                // Update to server
                NetworkController.shared.update(id: todo.id, todoBase: todo.todoBase, actionHandler: { _ in })
            }
        }
    }

}
