//
//  Texts.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

/**
 Stores localized texts
 */
class Texts {

    static let archive = "Archive".localized
    static let cancel = "Cancel".localized
    static let live = "Live".localized
    static let ok = "OK".localized
    static let supportPackage = "Support Package".localized
    static let today = "Today".localized
    static let tomorrow = "Tomorrow".localized
    static let yesterday = "Yesterday".localized

    // MARK: - View Controllers

    class TodosTableViewController {
        static let viewControllerTitle = "Todos".localized
    }

    class TodoTableViewController {
        static let title = "Title".localized
        static let delete = "Delete".localized
        static let description = "Description".localized
        static let descriptionTextFieldPlaceholder = Texts.TodoTableViewController.description
        static let done = "Done".localized
        static let dueDate = "Due date".localized
        static let plusOneDay = "+1 day".localized
        static let plusOneMonth = "+1 month".localized
        static let plusOneWeek = "+1 week".localized
        static let plusOneYear = "+1 year".localized
        static let titleTextFieldPlaceholder = "Title".localized
        static let today = Texts.today
        static let viewControllerTitle = "Todo".localized
    }

    class SettingsTableViewController {
        static let generateSupportPackage = "Generate support package".localized
        static let serverAddress = "Server address".localized
        static let viewControllerTitle = "Settings".localized
    }

}
