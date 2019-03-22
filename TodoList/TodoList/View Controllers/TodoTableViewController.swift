//
//  TodoTableViewController.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

protocol TodoTableViewControllerDelegate: class {

    func abort()
    func back()
    func delete()
    func save()

}

class TodoTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerButtonDelete: UIButton!
    @IBOutlet weak var datePickerButtonToday: UIButton!
    @IBOutlet weak var datePickerButtonPlusOneDay: UIButton!
    @IBOutlet weak var datePickerButtonPlusOneWeek: UIButton!
    @IBOutlet weak var datePickerButtonPlusOneMonth: UIButton!
    @IBOutlet weak var datePickerButtonPlusOneYear: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var doneTitleLabel: UILabel!
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBOutlet weak var deleteButton: UIBarButtonItem!

    weak var delegate: TodoTableViewControllerDelegate?

    /// Index path of the date picker
    static let datePickerIndexPath = IndexPath(row: 0, section: 1)

    var todo: Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Localization
        self.title = Texts.TodoTableViewController.title
        self.titleTextField.placeholder = Texts.TodoTableViewController.titleTextFieldPlaceholder
        self.datePickerButtonDelete.setTitle(Texts.TodoTableViewController.delete, for: .normal)
        self.datePickerButtonToday.setTitle(Texts.TodoTableViewController.today, for: .normal)
        self.datePickerButtonPlusOneDay.setTitle(Texts.TodoTableViewController.plusOneDay, for: .normal)
        self.datePickerButtonPlusOneWeek.setTitle(Texts.TodoTableViewController.plusOneWeek, for: .normal)
        self.datePickerButtonPlusOneMonth.setTitle(Texts.TodoTableViewController.plusOneMonth, for: .normal)
        self.datePickerButtonPlusOneYear.setTitle(Texts.TodoTableViewController.plusOneYear, for: .normal)
        self.descriptionTextField.placeholder = Texts.TodoTableViewController.descriptionTextFieldPlaceholder
        self.doneTitleLabel.text = Texts.TodoTableViewController.done
        self.hideDatePicker()
        self.loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Is only called when back button is touched
        if self.isMovingFromParent {
            // Update from UI
            self.todo?.desc = self.descriptionTextField.text
            self.todo?.done = self.doneSwitch.isOn
            self.todo?.dueDate = self.datePicker.date
            self.todo?.title = self.titleTextField.text ?? ""
            self.delegate?.back()
        }
    }

    func loadData() {
        // If a todo is already provided, load its data
        if let todo = self.todo {
            self.titleTextField.text = todo.title
            self.dueDateLabel.text = todo.dueDate.simpleDateString
            self.datePicker.date = todo.dueDate
            self.descriptionTextField.text = todo.desc
            self.doneSwitch.isOn = todo.done
        }
    }

    func hideDatePicker() {
        self.datePicker.isHidden = true
        self.datePickerButtonDelete.isHidden = true
        self.datePickerButtonToday.isHidden = true
        self.datePickerButtonPlusOneDay.isHidden = true
        self.datePickerButtonPlusOneWeek.isHidden = true
        self.datePickerButtonPlusOneMonth.isHidden = true
        self.datePickerButtonPlusOneYear.isHidden = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Texts.TodoTableViewController.title
        case 1:
            return Texts.TodoTableViewController.dueDate
        case 2:
            return Texts.TodoTableViewController.description
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == TodoTableViewController.datePickerIndexPath {
            self.datePicker.isHidden = !self.datePicker.isHidden
            self.datePickerButtonDelete.isHidden = !self.datePickerButtonDelete.isHidden
            self.datePickerButtonToday.isHidden = !self.datePickerButtonToday.isHidden
            self.datePickerButtonPlusOneDay.isHidden = !self.datePickerButtonPlusOneDay.isHidden
            self.datePickerButtonPlusOneWeek.isHidden = !self.datePickerButtonPlusOneWeek.isHidden
            self.datePickerButtonPlusOneMonth.isHidden = !self.datePickerButtonPlusOneMonth.isHidden
            self.datePickerButtonPlusOneYear.isHidden = !self.datePickerButtonPlusOneYear.isHidden
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == TodoTableViewController.datePickerIndexPath && !self.datePicker.isHidden {
            return CGFloat(330)
        }
        return CGFloat(50)
    }

    // MARK: - Navigation

    @IBAction func deleteTodo(_ sender: UIBarButtonItem) {
        self.delegate?.delete()
    }

    @IBAction func datePickerDidChange(_ sender: UIDatePicker) {
        self.dueDateLabel.text = self.datePicker.date.simpleDateString
    }

    @IBAction func dateDelete(_ sender: UIButton) {
    }

    @IBAction func dateToday(_ sender: UIButton) {
        self.datePicker.date = Date()
        self.dueDateLabel.text = self.datePicker.date.simpleDateString
    }

    @IBAction func datePlusOneDay(_ sender: UIButton) {
        self.datePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: self.datePicker.date)!
        self.dueDateLabel.text = self.datePicker.date.simpleDateString
    }

    @IBAction func datePlusOneWeek(_ sender: Any) {
        self.datePicker.date = Calendar.current.date(byAdding: .day, value: 7, to: self.datePicker.date)!
        self.dueDateLabel.text = self.datePicker.date.simpleDateString
    }

    @IBAction func datePlusOneMonth(_ sender: Any) {
        self.datePicker.date = Calendar.current.date(byAdding: .month, value: 1, to: self.datePicker.date)!
        self.dueDateLabel.text = self.datePicker.date.simpleDateString
    }

    @IBAction func datePlusOneYear(_ sender: Any) {
        self.datePicker.date = Calendar.current.date(byAdding: .year, value: 1, to: self.datePicker.date)!
        self.dueDateLabel.text = self.datePicker.date.simpleDateString
    }

}
