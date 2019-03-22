//
//  Todo.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import CoreStore
import Foundation

class Todo: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var desc: String?
    @NSManaged var done: Bool
    @NSManaged var dueDate: Date
    @NSManaged var title: String

    var todoBase: TodoBase {
        return TodoBase(desc: self.desc, done: self.done, dueDate: self.dueDate.rfc3339String, title: self.title)
    }

    static func delete(_ ids: Set<Int32>) {
        Database.dataStack.perform(asynchronous: { transaction in
            for id in ids {
                if let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) {
                    transaction.delete(todo)
                }
            }
        }, completion: { _ in })
    }

    static func save(_ todoListList: [TodoList]) {
        Database.dataStack.perform(asynchronous: { transaction in
            // Store current todo IDs to track deleted switches
            var oldIds = Set((transaction.fetchAll(From<Todo>()) ?? []).map { $0.id })
            for todoList in todoListList {
                guard let id = todoList.id, let done = todoList.done, let dueDate = todoList.dueDate?.rfc3339date, let title = todoList.title else {
                    continue
                }
                let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) ?? transaction.create(Into<Todo>())
                todo.id = id
                todo.done = done
                todo.dueDate = dueDate
                todo.title = title
                // Remove id from set
                oldIds.remove(id)
            }
            // Delete todos with IDs not seen
            Todo.delete(oldIds)
        }, completion: { _ in })
    }

    func toggle() {
        let done = !self.done
        // Update from server
        NetworkController.shared.get(id: self.id) { _, todoFull in
            // Update database
            self.update(todoFull) { todo  in
                todo.done = done
                // Update to server
                NetworkController.shared.update(id: todo.id, todoBase: todo.todoBase, actionHandler: { _ in })
            }
        }
    }

    func update(_ todoFull: TodoFull, completion: @escaping (_ todo: Todo) -> Void) {
        guard let id = todoFull.id, let done = todoFull.done, let dueDate = todoFull.dueDate?.rfc3339date, let title = todoFull.title else {
            return
        }
        Database.dataStack.perform(asynchronous: { transaction in
            guard let todo = transaction.edit(self) else {
                return
            }
            todo.id = id
            todo.desc = todoFull.desc
            todo.done = done
            todo.dueDate = dueDate
            todo.title = title
        }, completion: { _ in
            if let todo = Database.dataStack.fetchOne(From<Todo>().where(\.id == id)) {
                completion(todo)
            }
        })
    }

}
