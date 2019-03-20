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
    // Set global colors
    UIView.appearance().tintColor = QColor.blue.color
    UIView.appearance(whenContainedInInstancesOf: [QTableViewCell.self]).tintColor = UIColor.white
    // QLog settings
    QLog.Texts.archive = "Archive".localized
    QLog.Texts.live = "Live".localized
    QLog.Texts.supportPackage = "Support Package".localized
    QLog.loggers = [XcodeLogger(), FileLogger(), UiLogger.shared]
    QLog.colorHighlight = QColor.purple.color
    QLog.colorDebug = QColor.blue.color
    QLog.colorInfo = QColor.green.color
    QLog.colorWarning = QColor.yellow.color
    QLog.colorError = QColor.red.color
    // Fonts of navigation bars cannot be changed with UIFont extension, so we do it with the appearance proxy here
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .normal)
    // Remove shadow from bars
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = false
    UITabBar.appearance().shadowImage = UIImage()
    UITabBar.appearance().backgroundImage = UIImage()
    UITabBar.appearance().backgroundColor = UIColor.white
}
