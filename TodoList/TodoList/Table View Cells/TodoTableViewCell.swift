//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

protocol TodoTableViewCellDelegate: class {

    /**
     Toggles the done state of a todo
     - parameter todo: The todo to toggle
     */
    func toggle(_ todo: Todo)

}

class TodoTableViewCell: QTableViewCell {

    @IBOutlet weak var doneSwitch: QSwitch!
    @IBOutlet weak var titleLabel: QLabel!

    weak var delegate: TodoTableViewCellDelegate?

    var todo: Todo!

    /**
     Sets the UI elements of the table view cell
     - parameter todo: The todo object of the cell
     */
    func set(_ todo: Todo) {
        self.todo = todo
        self.doneSwitch.on = todo.done
        self.titleLabel.text = todo.title
    }

    // MARK: - Navigation

    /**
     Updates the UI and forwards toggling to the delegate
     - parameter sender: The sender of the action
     */
    @IBAction func toggleDoneSwitch(_ sender: AnyObject) {
        // Update UI
        self.doneSwitch.on = !self.doneSwitch.on
        self.delegate?.toggle(todo)
    }

}
