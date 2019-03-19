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
                guard let id = todoList.id, let done = todoList.done, let dueData = todoList.dueDate, let title = todoList.title else {
                    continue
                }
                let todo = transaction.fetchOne(From<Todo>().where(\.id == id)) ?? transaction.create(Into<Todo>())
                todo.id = id
                todo.done = done
                todo.dueDate = Date()
                todo.title = title
                // Remove id from set
                oldIds.remove(id)
            }
            // Delete todos with IDs not seen
            Todo.delete(oldIds)
        }
    }

}
