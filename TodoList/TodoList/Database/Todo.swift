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

    static func delete(_ ids: Set<Int32>, transaction: BaseDataTransaction? = nil) {
        Database.execute(transaction: transaction) { transaction in
            for id in ids {
                if let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) {
                    transaction.delete(todo)
                }
            }
        }
    }

    static func save(_ todoListList: [TodoList]) {
        Database.execute { transaction in
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
        }
    }

    func edit(transaction: BaseDataTransaction? = nil, handler: @escaping (_ todo: Todo, _ transaction: BaseDataTransaction) -> Void) {
        Database.edit(self, transaction: transaction, handler: handler)
    }

    func edit(transaction: BaseDataTransaction? = nil, handler: @escaping (_ todo: Todo, _ transaction: BaseDataTransaction) -> Void, completion: @escaping () -> Void) {
        Database.edit(self, transaction: transaction, handler: handler, completion: completion)
    }

    func toggle() {
        let done = !self.done
        // Update data from server
        NetworkController.shared.get(id: self.id) { _, todoFull in
            self.update(todoFull, completion: {})
        }
        // Toggle todo and update server
        self.edit { todo, _ in
            todo.done = done
            // Update server
            NetworkController.shared.update(id: todo.id, todoBase: todo.todoBase, actionHandler: { _ in })
        }
    }

    func update(_ todoFull: TodoFull, completion: @escaping () -> Void) {
        self.edit(handler: { todo, _ in
            guard let id = todoFull.id, let done = todoFull.done, let dueDate = todoFull.dueDate?.rfc3339date, let title = todoFull.title else {
                return
            }
            todo.id = id
            todo.desc = todoFull.desc
            todo.done = done
            todo.dueDate = dueDate
            todo.title = title
        }, completion: {
            completion()
        })
    }

}
