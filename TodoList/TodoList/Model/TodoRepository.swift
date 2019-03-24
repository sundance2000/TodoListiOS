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

    func delete(_ todo: Todo) {
        Database.dataStack.perform(asynchronous: { transaction in
            guard let todo = transaction.edit(todo) else {
                return
            }
            transaction.delete(todo)
        }, completion: { _ in })
    }

    func delete(_ ids: Set<Int32>) {
        Database.dataStack.perform(asynchronous: { transaction in
            for id in ids {
                if let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) {
                    transaction.delete(todo)
                }
            }
        }, completion: { _ in })
    }

    func save(_ todoFull: TodoFull) {
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
            todo.dueDay = dueDate.dayString.dayDate ?? dueDate
            todo.title = title
        }, completion: { _ in })
    }

    func save(_ todoListList: [TodoList]) {
        Database.dataStack.perform(asynchronous: { transaction in
            // Store current todo IDs to track deleted switches
            var oldIds = Set((transaction.fetchAll(From<Todo>()) ?? []).map { $0.id })
            for todoList in todoListList {
                guard let id = todoList.id, let done = todoList.done, let dueDate = todoList.dueDate?.rfc3339date, let title = todoList.title else {
                    QLogError("todo is incomplete: \(todoList)")
                    continue
                }
                let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) ?? transaction.create(Into<Todo>())
                todo.id = id
                todo.done = done
                todo.dueDate = dueDate
                todo.dueDay = dueDate.dayString.dayDate ?? dueDate
                todo.title = title
                // Remove id from set
                oldIds.remove(id)
            }
            // Delete todos with IDs not seen
            self.delete(oldIds)
        }, completion: { _ in })
    }

    func update(_ todo: Todo, with todoFull: TodoFull, completion: @escaping (_ todo: Todo) -> Void) {
        guard let id = todoFull.id, let done = todoFull.done, let dueDate = todoFull.dueDate?.rfc3339date, let title = todoFull.title else {
            return
        }
        Database.dataStack.perform(asynchronous: { transaction in
            guard let todo = transaction.edit(todo) else {
                return
            }
            todo.id = id
            todo.desc = todoFull.desc
            todo.done = done
            todo.dueDate = dueDate
            todo.dueDay = dueDate.dayString.dayDate ?? dueDate
            todo.title = title
        }, completion: { _ in
            if let todo = Database.dataStack.fetchOne(From<Todo>().where(\.id == id)) {
                completion(todo)
            }
        })
    }

}
