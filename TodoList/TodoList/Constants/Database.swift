//
//  Database.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import CoreStore
import Foundation
import QLog

/**
 Stores database information
 */
struct Database {

    static let modelName = App.name

    /// The CoreStore data stack of the application
    static let dataStack: DataStack = {
        let dataStack = DataStack(xcodeModelName: Database.modelName)
        do {
            try dataStack.addStorageAndWait(SQLiteStore(fileName: Database.modelName, configuration: "Default", localStorageOptions: .
                recreateStoreOnModelMismatch))
        } catch let error {
            QLogError("Cannot set up database storage: \(error)")
        }
        return dataStack
    }()

}
