//
//  TodosTableViewController.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import CoreStore
import UIKit

protocol TodosTableViewControllerDelegate: class {

    func selectTodo(_ todo: Todo)
    func toggleTodo(_ todo: Todo)

}

class TodosTableViewController: UITableViewController {

    let monitor = Database.dataStack.monitorList(From<Todo>()
        .orderBy(.ascending("dueDate"), .ascending("title"), .ascending("id"))
        .tweak { $0.fetchBatchSize = 20 }
    )

    weak var delegate: TodosTableViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheme()
        // Register self as observer to monitor
        self.monitor.addObserver(self)
        // Remove empty cells
        self.tableView.tableFooterView = UIView()
        // Register table cell class from nib
        self.tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoTableViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.monitor.numberOfObjects()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        let todo = self.monitor[(indexPath as NSIndexPath).row]
        cell.set(todo)
        return cell
    }

    // MARK: - Navigation

}

// MARK: - ListObserver

extension TodosTableViewController: ListObserver {

    func listMonitorWillChange(_ monitor: ListMonitor<Todo>) {
        self.tableView.beginUpdates()
    }

    func listMonitorDidChange(_ monitor: ListMonitor<Todo>) {
        self.tableView.endUpdates()
    }

    func listMonitorWillRefetch(_ monitor: ListMonitor<Todo>) {
    }

    func listMonitorDidRefetch(_ monitor: ListMonitor<Todo>) {
        self.tableView.reloadData()
    }

}

// MARK: - ListObjectObserver

extension TodosTableViewController: ListObjectObserver {

    func listMonitor(_ monitor: ListMonitor<Todo>, didInsertObject object: Todo, toIndexPath indexPath: IndexPath) {
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func listMonitor(_ monitor: ListMonitor<Todo>, didDeleteObject object: Todo, fromIndexPath indexPath: IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func listMonitor(_ monitor: ListMonitor<Todo>, didUpdateObject object: Todo, atIndexPath indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? TodoTableViewCell {
            cell.set(object)
        }
    }

    func listMonitor(_ monitor: ListMonitor<Todo>, didMoveObject object: Todo, fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        self.tableView.deleteRows(at: [fromIndexPath], with: .automatic)
        self.tableView.insertRows(at: [toIndexPath], with: .automatic)
    }

}

// MARK: - TodosTableViewControllerDelegate

extension TodosTableViewController: TodoTableViewCellDelegate {

    func selectTodo(_ todo: Todo) {
        self.delegate?.selectTodo(todo)
    }

    func toggleTodo(_ todo: Todo) {
        self.delegate?.toggleTodo(todo)
    }

}
