//
//  TodoTableViewCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

/// Coordinates handling of todos table
class TodoTableViewCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let todoTableViewController: TodoTableViewController

    private var todo: Todo?

    /**
     Creates a new apps table coordinator
     - parameter navigationController: The navigation controller to use
     */
    init(navigationController: UINavigationController, todo: Todo? = nil) {
        self.navigationController = navigationController
        self.todo = todo
        let storyboard = UIStoryboard(name: "TodoTableViewController", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController()!
        self.todoTableViewController = navigationController.children[0] as! TodoTableViewController
        self.todoTableViewController.delegate = self
        self.todoTableViewController.todo = self.todo
    }

    func start() {
        self.navigationController.pushViewController(self.todoTableViewController, animated: true)
        NetworkController.shared.list(state: "all") { statusCode, todoList in
            Todo.save(todoList)
        }
    }

}

// MARK: - TodosTableViewControllerDelegate

extension TodoTableViewCoordinator: TodoTableViewControllerDelegate {

    func abort() {

    }

    func back() {

    }

    func save() {
        
    }


}
