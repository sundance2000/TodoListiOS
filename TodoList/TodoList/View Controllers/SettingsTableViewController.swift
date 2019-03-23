//
//  SettingsTableViewController.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 23.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate: class {

    func generateSupportPackage()
    func save()

}

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var serverAddressTextField: UITextField!

    weak var delegate: SettingsTableViewControllerDelegate?

    var serverAddress: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Localization
        self.title = Texts.SettingsTableViewController.viewControllerTitle
        // Load data
        self.serverAddressTextField.text = self.serverAddress
        // Add bar buttons
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
    }

    override func viewWillAppear(_ animated: Bool) {
        // Add toolbar button
        let generateSupportPackageBarButtonItem = UIBarButtonItem(title: Texts.SettingsTableViewController.generateSupportPackage, style: .plain, target: self, action: #selector(generateSupportPackage))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.toolbarItems = [spacer, generateSupportPackageBarButtonItem, spacer]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Texts.SettingsTableViewController.serverAddress
        default:
            return ""
        }
    }

    // MARK: - Navigation

    @objc func generateSupportPackage() {
        self.delegate?.generateSupportPackage()
    }

    @objc func save() {
        self.delegate?.save()
    }

}
