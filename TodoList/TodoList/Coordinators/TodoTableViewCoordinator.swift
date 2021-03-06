//
//  TodoTableViewCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import QLog
import UIKit

/**
 Coordinates handling of todo table
 */
class TodoTableViewCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let todoTableViewController: TodoTableViewController

    private var todo: Todo?

    /**
     Creates a new todo table coordinator
     - parameter navigationController: The navigation controller to use
     */
    init(navigationController: UINavigationController, todo: Todo? = nil) {
        self.navigationController = navigationController
        self.todo = todo
        let storyboard = UIStoryboard(name: "TodoTableViewController", bundle: nil)
        self.todoTableViewController = storyboard.instantiateInitialViewController()! as! TodoTableViewController
        super.init()
        self.todoTableViewController.delegate = self
        self.todoTableViewController.todo = self.todo
    }

    /**
     Pushes the view controller onto the stack or presents it modally,
     depending on the todo object
     */
    func start() {
        // If no todo is set, show view controller modally to create a new todo
        if self.todo == nil {
            let navigationController = UINavigationController(rootViewController: self.todoTableViewController)
            self.navigationController.present(navigationController, animated: true)
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
        guard let todo = self.todo else {
            QLogError("Todo is nil")
            return
        }
        let id = todo.id
        let desc = self.todoTableViewController.descriptionTextField.text
        let done = self.todoTableViewController.doneSwitch.isOn
        let dueDate = self.todoTableViewController.datePicker.date.rfc3339String
        let title = self.todoTableViewController.titleTextField.text ?? ""
        let todoBase = TodoBase(desc: desc, done: done, dueDate: dueDate, title: title)
        let todoFull = TodoFull(id: id, desc: desc, done: done, dueDate: dueDate, title: title)
        // Update to server
        NetworkService.shared.update(id: id, todoBase: todoBase) { _ in
            // Update database
            TodoRepository.shared.update(todo, with: todoFull)
        }
    }

    func cancel() {
        self.todoTableViewController.dismiss(animated: true)
    }

    func delete() {
        guard let todo = self.todo else {
            QLogError("Todo is nil")
            return
        }
        // Update to server
        NetworkService.shared.delete(id: todo.id) { _ in
            // Update database
            TodoRepository.shared.delete(todo)
        }
        self.navigationController.popViewController(animated: true)
    }

    func save() {
        let desc = self.todoTableViewController.descriptionTextField.text
        let done = self.todoTableViewController.doneSwitch.isOn
        let dueDate = self.todoTableViewController.datePicker.date.rfc3339String
        let title = self.todoTableViewController.titleTextField.text ?? ""
        let todoBase = TodoBase(desc: desc, done: done, dueDate: dueDate, title: title)
        self.todoTableViewController.dismiss(animated: true)
        // Update to server
        NetworkService.shared.create(todoBase: todoBase) { _, todoFull in
            // Update database
            TodoRepository.shared.save(todoFull)
        }
    }

}
