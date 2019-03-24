//
//  Service.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 24.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation

/**
 The service protocol
 */
protocol ServiceProtocol: class {

    /**
     Starts the service
     */
    func start()

}

typealias Service = Component & ServiceProtocol
