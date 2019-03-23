//
//  Controller.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 23.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation
import QLog

protocol ComponentProtocol: class {

    var shuttingDown: Bool { get set }
    var started: Bool { get set }

    /**
     Starts the controller and executes the action handler.
     - parameter handler: The action handler
     - parameter silently: Set true to suppress INFO log output about start
     */
    func start(silently: Bool, _ handler: @escaping (() -> Void))

    /**
     Shuts the controller down and executes an action handler.
     If the controller is already shutting down, the shutdown is not performed.
     - parameter handler: The action handler
     - parameter silently: Set true to suppress INFO log output about shutdown
     */
    func shutdown(silently: Bool, _ handler: @escaping (() -> Void))

}

/// Plain Component
class Component: ComponentProtocol, CustomStringConvertible {

    var shuttingDown: Bool = false
    var started: Bool = false

    var description: String {
        return "Component"
    }

    func start(silently: Bool = false, _ handler: @escaping (() -> Void)) {
        if !self.started {
            self.shuttingDown = false
            self.started = true
            if !silently {
                QLogInfo(" \(self) started")
            }
            handler()
        }
    }

    func shutdown(silently: Bool = false, _ handler: @escaping (() -> Void)) {
        if !self.shuttingDown {
            self.shuttingDown = true
            self.started = false
            if !silently {
                QLogInfo("\(self) shut down")
            }
            handler()
        }
    }

}
