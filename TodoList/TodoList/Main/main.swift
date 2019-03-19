//
//  main.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import QLog
import UIKit

// Genius solution from http://qualitycoding.org/app-delegate-for-tests/
let appDelegateClass: AnyClass? = NSClassFromString("TodoListTests.TestAppDelegate") ?? AppDelegate.self
let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
_ = UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(appDelegateClass!))

func main() {
    // QLog settings
    QLog.loggers = [XcodeLogger(logLevel: .highlight), FileLogger(), UiLogger.shared]

}
