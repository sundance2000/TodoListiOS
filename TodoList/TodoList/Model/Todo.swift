//
//  Todo.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import CoreStore
import Foundation
import QLog

class Todo: NSManagedObject {

    @NSManaged var id: Int32
    @NSManaged var desc: String?
    @NSManaged var done: Bool
    @NSManaged var dueDate: Date
    // Day without daytime to generate sections
    @NSManaged var dueDay: Date
    @NSManaged var title: String

    var todoBase: TodoBase {
        return TodoBase(desc: self.desc, done: self.done, dueDate: self.dueDate.rfc3339String, title: self.title)
    }

    var todoFull: TodoFull {
        return TodoFull(id: self.id, desc: self.desc, done: self.done, dueDate: self.dueDate.rfc3339String, title: self.title)
    }

}
