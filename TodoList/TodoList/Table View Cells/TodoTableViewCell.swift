//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelegate: class {

    func selectTodo(_ todo: Todo)
    func toggleTodo(_ todo: Todo)

}

class TodoTableViewCell: QTableViewCell {

    @IBOutlet weak var doneSwitch: QSwitch!
    @IBOutlet weak var titleButton: QButton!

    weak var delegate: TodoTableViewCellDelegate?

    var todo: Todo!

    func set(_ todo: Todo) {
        self.todo = todo
        self.doneSwitch.on = todo.done
        self.titleButton.label.text = todo.title
    }

    // MARK: - Navigation

    @IBAction func toggleDoneSwitch(_ sender: AnyObject) {
        // Update UI
        self.doneSwitch.on = !self.doneSwitch.on
        self.delegate?.toggleTodo(todo)
    }

    @IBAction func selectTodo(_ sender: Any) {
        self.delegate?.selectTodo(todo)
    }
    
}
