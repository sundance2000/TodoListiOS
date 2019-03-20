//
//  QTableViewController.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

public protocol QTableViewController: class {

    func setTheme()

}

extension UITableViewController: QTableViewController {

    public func setTheme() {
        self.tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 70
        self.tableView.backgroundColor = QColor.lightWhite.color
        self.view.backgroundColor = QColor.lightWhite.color
    }

}

extension UIViewController {

    // Taken from https://stackoverflow.com/a/27079103/5804550
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
