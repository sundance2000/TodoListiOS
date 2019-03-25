//
//  TodosTableViewCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

/**
 Coordinates handling of todos table
 */
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
        super.init()
        self.todosTableViewController.delegate = self
    }

    /**
     Pushes the view controller onto the stack
     */
    func start() {
        self.navigationController.pushViewController(self.todosTableViewController, animated: true)
    }

}

// MARK: - TodosTableViewControllerDelegate

extension TodosTableViewCoordinator: TodosTableViewControllerDelegate {

    func add() {
        // Create a new todo table view coordinator and start it
        self.todoTableViewCoordinator = TodoTableViewCoordinator(navigationController: self.navigationController, todo: nil)
        self.todoTableViewCoordinator?.start()
    }

    func delete(_ todo: Todo) {
        // Update to server
        NetworkService.shared.delete(id: todo.id) { _ in
            // Update database
            TodoRepository.shared.delete(todo)
        }
    }

    func select(_ todo: Todo) {
        // Update from server
        NetworkService.shared.get(id: todo.id) { _, todoFull in
            // Update database
            TodoRepository.shared.update(todo, with: todoFull) { todo in
                // Create a new todo table view coordinator and start it
                guard todo != nil else {
                    return
                }
                self.todoTableViewCoordinator = TodoTableViewCoordinator(navigationController: self.navigationController, todo: todo)
                self.todoTableViewCoordinator?.start()
            }
        }
    }

    func showSettings() {
        // Create a new settings table view coordinator and start it
        self.settingsTableViewCoordinator = SettingsTableViewCoordinator(navigationController: self.navigationController)
        self.settingsTableViewCoordinator?.start()
    }

    func toggle(_ todo: Todo) {
        let done = !todo.done
        let id = todo.id
        // Update from server
        NetworkService.shared.get(id: id) { _, todoFull in
            // Update to server
            let todoBase = TodoBase(desc: todoFull.desc, done: done, dueDate: todoFull.dueDate, title: todoFull.title)
            NetworkService.shared.update(id: id, todoBase: todoBase) { _ in
                // Update database
                let todoFullNew = TodoFull(id: todoFull.id, desc: todoFull.desc, done: done, dueDate: todoFull.dueDate, title: todoFull.title)
                TodoRepository.shared.update(todo, with: todoFullNew)
            }
        }
    }

}
