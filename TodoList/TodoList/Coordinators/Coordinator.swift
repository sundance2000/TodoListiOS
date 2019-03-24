//
//  Coordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation

/**
 The coordinator protocol
 */
protocol CoordinatorProtocol: class {

    /**
     Starts the coordinator and pushes the corresponding view controller
     */
    func start()

}

typealias Coordinator = Component & CoordinatorProtocol
