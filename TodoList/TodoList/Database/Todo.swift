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

    @NSManaged var id: Int
    @NSManaged var desc: String?
    @NSManaged var done: Bool
    @NSManaged var dueDate: Date
    @NSManaged var title: String

}
