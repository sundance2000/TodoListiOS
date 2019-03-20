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

    /**
     Creates a new apps table coordinator
     - parameter navigationController: The navigation controller to use
     */
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.todosTableViewController = TodosTableViewController()
        self.todosTableViewController.delegate = self
    }

    func start() {
        self.navigationController.navigationBar.topItem?.title = "Todos"
        self.navigationController.pushViewController(self.todosTableViewController, animated: true)
        NetworkController.shared.list { statusCode, todoList in
            Todo.save(todoList)
        }
    }

}

// MARK: - TodosTableViewControllerDelegate

extension TodosTableViewCoordinator: TodosTableViewControllerDelegate {

}