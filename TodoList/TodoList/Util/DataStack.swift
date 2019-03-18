//
//  DataStack.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import CoreStore

extension DataStack {

    public func edit<T: DynamicObject>(_ object: T, transaction: BaseDataTransaction? = nil, handler: @escaping (_ object: T, _ transaction: BaseDataTransaction) -> Void) {
        if let transaction = transaction {
            guard let object = transaction.edit(object) else {
                return
            }
            handler(object, transaction)
        } else {
            self.perform(asynchronous: { transaction in
                guard let object = transaction.edit(object) else {
                    return
                }
                handler(object, transaction)
            }, completion: { _ in })
        }
    }

    public func edit<T: DynamicObject>(_ object: T, transaction: BaseDataTransaction? = nil, handler: @escaping (_ object: T, _ transaction: BaseDataTransaction) -> Void, completion: @escaping () -> Void) {
        if let transaction = transaction {
            guard let object = transaction.edit(object) else {
                return
            }
            handler(object, transaction)
            completion()
        } else {
            self.perform(asynchronous: { transaction in
                guard let object = transaction.edit(object) else {
                    return
                }
                handler(object, transaction)
            }, completion: { _ in
                completion()
            })
        }
    }

    public func execute(transaction: BaseDataTransaction? = nil, handler: @escaping (_ transaction: BaseDataTransaction) -> Void) {
        if let transaction = transaction {
            handler(transaction)
        } else {
            self.perform(asynchronous: { transaction in
                handler(transaction)
            }, completion: { _ in })
        }
    }

    public func execute(transaction: BaseDataTransaction? = nil, handler: @escaping (_ transaction: BaseDataTransaction) -> Void, completion: @escaping () -> Void) {
        if let transaction = transaction {
            handler(transaction)
            completion()
        } else {
            self.perform(asynchronous: { transaction in
                handler(transaction)
            }, completion: { _ in
                completion()
            })
        }
    }

    public func getString<T: DynamicObject>(from object: T, transaction: BaseDataTransaction? = nil, handler: @escaping (_ object: T, _ transaction: BaseDataTransaction) -> String?) -> String? {
        if let transaction = transaction {
            guard let object = transaction.fetchExisting(object) else {
                return nil
            }
            return handler(object, transaction)
        } else {
            let semaphore = DispatchSemaphore(value: 0)
            var string: String?
            self.execute { transaction in
                guard let object = transaction.fetchExisting(object) else {
                    semaphore.signal()
                    return
                }
                guard let result = handler(object, transaction) else {
                    semaphore.signal()
                    return
                }
                string = result
                semaphore.signal()
            }
            semaphore.wait()
            return string
        }
    }

}
