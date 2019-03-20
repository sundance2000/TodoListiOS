//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

class TodoTableViewCell: QTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    var todo: Todo!

    func set(_ todo: Todo) {
        self.titleLabel.text = todo.title
    }

}
