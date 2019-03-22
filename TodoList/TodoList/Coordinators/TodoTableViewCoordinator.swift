//
//  TodoTableViewCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import QLog
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
        self.todoTableViewController = storyboard.instantiateInitialViewController()! as! TodoTableViewController
        self.todoTableViewController.delegate = self
        self.todoTableViewController.todo = self.todo
    }

    func start() {
        // If no todo is set, show view controller modally to create a new todo
        if self.todo == nil {
            let navigationContoller = UINavigationController(rootViewController: self.todoTableViewController)
            self.navigationController.present(navigationContoller, animated: true)
        } else {
            // Else push the view controller to show an existing todo
            self.navigationController.setToolbarHidden(false, animated: true)
            self.navigationController.pushViewController(self.todoTableViewController, animated: true)
        }
    }

}

// MARK: - TodosTableViewControllerDelegate

extension TodoTableViewCoordinator: TodoTableViewControllerDelegate {

    func back() {
        self.navigationController.setToolbarHidden(true, animated: true)
        guard let todoFull = self.todo?.todoFull else {
            QLogError("Todo is nil")
            return
        }
        // Update database
        self.todo?.update(todoFull) { todo  in
            // Update to server
            NetworkController.shared.update(id: todo.id, todoBase: todo.todoBase) { _ in }
        }
    }

    func cancel() {
        self.todoTableViewController.dismiss(animated: true)
    }

    func delete() {
        self.navigationController.popViewController(animated: true)
        guard let todo = self.todo else {
            QLogError("Todo is nil")
            return
        }
        // Update database
        todo.delete() {
            // Update to server
            NetworkController.shared.delete(id: todo.id) { _ in }
        }
    }

    func save(_ todoBase: TodoBase) {
        self.todoTableViewController.dismiss(animated: true)
        // Update to server
        NetworkController.shared.create(todoBase: todoBase) { _, todoFull in
            // Update database
            Todo.save(todoFull)
        }
    }

}
