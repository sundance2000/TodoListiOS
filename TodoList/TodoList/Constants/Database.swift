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

struct Database {

    static let modelName = App.name

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
