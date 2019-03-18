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

    static func edit<T: DynamicObject>(_ object: T, transaction: BaseDataTransaction? = nil, handler: @escaping (_ object: T, _ transaction: BaseDataTransaction) -> Void) {
        Database.dataStack.edit(object, transaction: transaction, handler: handler)
    }

    static func edit<T: DynamicObject>(_ object: T, transaction: BaseDataTransaction? = nil, handler: @escaping (_ object: T, _ transaction: BaseDataTransaction) -> Void, completion: @escaping () -> Void) {
        Database.dataStack.edit(object, transaction: transaction, handler: handler, completion: completion)
    }

    static func execute(transaction: BaseDataTransaction? = nil, handler: @escaping (_ transaction: BaseDataTransaction) -> Void) {
        Database.dataStack.execute(transaction: transaction, handler: handler)
    }

    static func execute(transaction: BaseDataTransaction? = nil, handler: @escaping (_ transaction: BaseDataTransaction) -> Void, completion: @escaping () -> Void) {
        Database.dataStack.execute(transaction: transaction, handler: handler, completion: completion)
    }

    static func getString<T: DynamicObject>(from object: T, transaction: BaseDataTransaction? = nil, handler: @escaping (_ object: T, _ transaction: BaseDataTransaction) -> String?) -> String? {
        return Database.dataStack.getString(from: object, transaction: transaction, handler: handler)
    }

}
