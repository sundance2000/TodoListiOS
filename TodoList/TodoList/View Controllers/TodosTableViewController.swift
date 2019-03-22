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

    func add()
    func delete(_ todo: Todo)
    func select(_ todo: Todo)
    func toggle(_ todo: Todo)

}

class TodosTableViewController: UITableViewController {

    let monitor = Database.dataStack.monitorSectionedList(From<Todo>()
        .sectionBy(\.dueDay)
        .orderBy(.ascending("dueDay"), .ascending("title"), .ascending("id"))
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
        // Add bar buttons
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.monitor.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.monitor.numberOfObjectsInSection(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        let todo = self.monitor[(indexPath as NSIndexPath).row]
        cell.set(todo)
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let todo = self.monitor[IndexPath(item: 0, section: section)]
        let date = todo.dueDate
        if Calendar.current.isDateInYesterday(date) {
            return Texts.yesterday
        } else if Calendar.current.isDateInToday(date) {
            return Texts.today
        } else if Calendar.current.isDateInTomorrow(date) {
            return Texts.tomorrow
        } else {
            return date.dayString
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = self.monitor[(indexPath as NSIndexPath).row]
        self.delegate?.select(todo)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = self.monitor[(indexPath as NSIndexPath).row]
            self.delegate?.delete(todo)
        }
    }

    // MARK: - Navigation

    @objc func add() {
        self.delegate?.add()
    }

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

// MARK: - ListSectionObserver

extension TodosTableViewController: ListSectionObserver {

    func listMonitor(_ monitor: ListMonitor<Todo>, didInsertSection sectionInfo: NSFetchedResultsSectionInfo, toSectionIndex sectionIndex: Int) {
        self.tableView.insertSections([sectionIndex], with: .automatic)
    }

    func listMonitor(_ monitor: ListMonitor<Todo>, didDeleteSection sectionInfo: NSFetchedResultsSectionInfo, fromSectionIndex sectionIndex: Int) {
        self.tableView.deleteSections([sectionIndex], with: .automatic)
    }

}

// MARK: - TodosTableViewControllerDelegate

extension TodosTableViewController: TodoTableViewCellDelegate {

    func toggle(_ todo: Todo) {
        self.delegate?.toggle(todo)
    }

}
