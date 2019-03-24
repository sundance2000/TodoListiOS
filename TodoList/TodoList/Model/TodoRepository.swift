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

class TodoRepository: Repository {

    static var shared = {
        return TodoRepository()
    }()

    private override init() {
    }

    func delete(_ todo: Todo, completion: (() -> Void)? = nil) {
        Database.dataStack.perform(asynchronous: { transaction in
            guard let todo = transaction.edit(todo) else {
                return
            }
            transaction.delete(todo)
        }, completion: { _ in completion?() })
    }

    func delete(_ ids: Set<Int32>, completion: (() -> Void)? = nil) {
        Database.dataStack.perform(asynchronous: { transaction in
            for id in ids {
                if let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) {
                    transaction.delete(todo)
                }
            }
        }, completion: { _ in completion?() })
    }

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
