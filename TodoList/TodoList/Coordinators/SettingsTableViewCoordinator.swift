//
//  SettingsTableViewCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import SwiftyUserDefaults
import QLog
import UIKit

/**
 Coordinates handling of settings table
 */
class SettingsTableViewCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let settingsTableViewController: SettingsTableViewController

    /**
     Creates a new settings table coordinator
     - parameter navigationController: The navigation controller to use
     */
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let storyboard = UIStoryboard(name: "SettingsTableViewController", bundle: nil)
        self.settingsTableViewController = storyboard.instantiateInitialViewController()! as! SettingsTableViewController
        super.init()
        self.settingsTableViewController.delegate = self
    }

    /**
     Shows the view controller modally
     */
    func start() {
        self.settingsTableViewController.serverAddress = Defaults[.serverAddress]
        let navigationController = UINavigationController(rootViewController: self.settingsTableViewController)
        navigationController.setToolbarHidden(false, animated: true)
        self.navigationController.present(navigationController, animated: true)
    }

}

// MARK: - TodosTableViewControllerDelegate

extension SettingsTableViewCoordinator: SettingsTableViewControllerDelegate {

    func generateSupportPackage() {
        QLog.generateSupportPackage(viewController: self.settingsTableViewController)
    }

    func save() {
        self.settingsTableViewController.dismiss(animated: true)
        guard let url = self.settingsTableViewController.serverAddressTextField.text?.httpsUrl else {
            QLogError("Invalid server address: \(String(describing: self.settingsTableViewController.serverAddressTextField.text))")
            return
        }
        Defaults[.serverAddress] = url.absoluteString
        NetworkService.shared.shutdown()
        NetworkService.shared.start()
    }

}
