//
//  TodoRepository.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 24.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import CoreStore
import Foundation
import QLog

/**
 The repository to manage todos
 */
class TodoRepository: Repository {

    static var shared = {
        return TodoRepository()
    }()

    private override init() {
    }

    /**
     Deletes a todo from the database
     - parameter todo: The todo to delete
     - parameter completion: The completion handler to be called when the transaction is completed
     */
    func delete(_ todo: Todo, completion: (() -> Void)? = nil) {
        Database.dataStack.perform(asynchronous: { transaction in
            guard let todo = transaction.edit(todo) else {
                return
            }
            transaction.delete(todo)
        }, completion: { _ in completion?() })
    }

    /**
     Deletes multiple todos from the database
     - parameter ids: A set of todo IDs to delete
     - parameter completion: The completion handler to be called when the transaction is completed
     */
    func delete(_ ids: Set<Int32>, completion: (() -> Void)? = nil) {
        Database.dataStack.perform(asynchronous: { transaction in
            for id in ids {
                if let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) {
                    transaction.delete(todo)
                }
            }
        }, completion: { _ in completion?() })
    }

    /**
     Saves a todo to the database
     - parameter todoFull: The TodoFull object containing the data of the todo
     - parameter completion: The completion handler to be called when the transaction is completed
     */
    func save(_ todoFull: TodoFull, completion: (() -> Void)? = nil) {
        Database.dataStack.perform(asynchronous: { transaction in
            guard let id = todoFull.id, let done = todoFull.done, let dueDate = todoFull.dueDate?.rfc3339date, let title = todoFull.title else {
                QLogError("todo is incomplete: \(todoFull)")
                return
            }
            let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) ?? transaction.create(Into<Todo>())
            todo.id = id
            todo.desc = todoFull.desc
            todo.done = done
            todo.dueDate = dueDate
            todo.dueDay = dueDate.dayString.dayDate!
            todo.title = title
        }, completion: { _ in completion?() })
    }

    /**
     Saves a multiple todos to the database
     - parameter todoListList: An array of TodoList objects containing the data of the todos
     - parameter completion: The completion handler to be called when the transaction is completed
     */
    func save(_ todoListList: [TodoList], completion: (() -> Void)? = nil) {
        var oldIds = Set<Int32>()
        Database.dataStack.perform(asynchronous: { transaction in
            // Store current todo IDs to track deleted switches
            oldIds = Set((transaction.fetchAll(From<Todo>())!).map { $0.id })
            for todoList in todoListList {
                guard let id = todoList.id, let done = todoList.done, let dueDate = todoList.dueDate?.rfc3339date, let title = todoList.title else {
                    QLogError("todo is incomplete: \(todoList)")
                    continue
                }
                let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) ?? transaction.create(Into<Todo>())
                todo.id = id
                todo.done = done
                todo.dueDate = dueDate
                todo.dueDay = dueDate.dayString.dayDate!
                todo.title = title
                // Remove id from set
                oldIds.remove(id)
            }
            // Delete todos with IDs not seen
        }, completion: { _ in self.delete(oldIds) { completion?() } })
    }

    /**
     Updates a todo and returns the updated todo via completion handler
     - parameter todo: The todo to update
     - parameter todoFull: The TodoFull object containing the data of the todo
     - parameter completion: The completion handler to be called when the transaction is completed
     - parameter todo: The updated todo
     */
    func update(_ todo: Todo, with todoFull: TodoFull, completion: ((_ todo: Todo?) -> Void)? = nil) {
        let id = todo.id
        Database.dataStack.perform(asynchronous: { transaction in
            guard let id = todoFull.id, let done = todoFull.done, let dueDate = todoFull.dueDate?.rfc3339date, let title = todoFull.title else {
                QLogError("todo is incomplete: \(todoFull)")
                return
            }
            guard let todo = transaction.edit(todo) else {
                return
            }
            todo.id = id
            todo.desc = todoFull.desc
            todo.done = done
            todo.dueDate = dueDate
            todo.dueDay = dueDate.dayString.dayDate!
            todo.title = title
        }, completion: { _ in
            completion?(Database.dataStack.fetchOne(From<Todo>().where(\.id == id)))
        })
    }

}
