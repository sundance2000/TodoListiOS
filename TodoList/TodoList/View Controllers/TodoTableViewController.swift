//
//  TodoTableViewController.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import QLog
import UIKit

protocol TodoTableViewControllerDelegate: class {

    /**
     Moves back to the previous view
     */
    func back()

    /**
     Cancels the modal view
     */
    func cancel()

    /**
     Deletes the todo
     */
    func delete()

    /**
     Saves the todo
     */
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

    weak var delegate: TodoTableViewControllerDelegate?

    /// Index path of the date picker
    static let datePickerIndexPath = IndexPath(row: 0, section: 1)

    var todo: Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Localization
        self.localize()
        // Set constraints for titleTextField
        self.titleTextField.smartInsertDeleteType = .no
        self.titleTextField.delegate = self
        // Hide date picker
        self.hideDatePicker()
        // Hide keyboard when tapping outside text field
        self.hideKeyboardWhenTappedAround()
        // Load data
        self.loadData()

    }

    override func viewWillAppear(_ animated: Bool) {
        if self.presentingViewController == nil {
            // Pushed
            let deleteBarButtonItem = UIBarButtonItem(title: Texts.TodoTableViewController.delete, style: .plain, target: self, action: #selector(deleteTodo))
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            self.toolbarItems = [spacer, deleteBarButtonItem, spacer]
        } else {
            // Modal
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Is only called when view controller was pushed
        if self.isMovingFromParent {
            self.delegate?.back()
        }
    }

    /**
     Loads the data from the todo object or sets defaults
     */
    private func loadData() {
        // If a todo is already provided, load its data
        if let todo = self.todo {
            self.titleTextField.text = todo.title
            self.dueDateLabel.text = todo.dueDate.simpleDateString
            self.datePicker.date = todo.dueDate
            self.descriptionTextField.text = todo.desc
            self.doneSwitch.isOn = todo.done
        } else {
            // Else set defaults
            self.datePicker.date = Date()
            self.dueDateLabel.text = self.datePicker.date.simpleDateString
        }
    }

    /**
     Localizes all UI elements
     */
    private func localize() {
        self.title = Texts.TodoTableViewController.viewControllerTitle
        self.titleTextField.placeholder = Texts.TodoTableViewController.titleTextFieldPlaceholder
        self.datePickerButtonDelete.setTitle("", for: .normal)
        self.datePickerButtonToday.setTitle(Texts.TodoTableViewController.today, for: .normal)
        self.datePickerButtonPlusOneDay.setTitle(Texts.TodoTableViewController.plusOneDay, for: .normal)
        self.datePickerButtonPlusOneWeek.setTitle(Texts.TodoTableViewController.plusOneWeek, for: .normal)
        self.datePickerButtonPlusOneMonth.setTitle(Texts.TodoTableViewController.plusOneMonth, for: .normal)
        self.datePickerButtonPlusOneYear.setTitle(Texts.TodoTableViewController.plusOneYear, for: .normal)
        self.descriptionTextField.placeholder = Texts.TodoTableViewController.descriptionTextFieldPlaceholder
        self.doneTitleLabel.text = Texts.TodoTableViewController.done
    }

    /**
     Hides the date picker
     */
    private func hideDatePicker() {
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

    /**
     Function to forward canceling to the delegate
     */
    @objc func cancel() {
        self.delegate?.cancel()
    }

    /**
     Function to forward saving to the delegate
     */
    @objc func save() {
        self.delegate?.save()
    }

    /**
     Function to forward deleting to the delegate
     */
    @objc func deleteTodo() {
        self.delegate?.delete()
    }

    @IBAction func titleTextFieldEditingChanged(_ sender: Any) {
        // Enable save button only if title is set
        if self.titleTextField.text == nil || self.titleTextField.text == "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
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

// MARK: - UITextFieldDelegate

// Extension to restrict the allowed number of characters in the title text field
// Taken from https://stackoverflow.com/a/25224331/5804550
extension TodoTableViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = self.titleTextField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }

}
