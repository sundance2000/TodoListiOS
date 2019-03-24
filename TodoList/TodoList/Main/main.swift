//
//  main.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import GameIcons
import QLog
import UIKit

// Genius solution from http://qualitycoding.org/app-delegate-for-tests/
// This call allows to exchange the app delegate for faster testing
let appDelegateClass: AnyClass? = NSClassFromString("TodoListTests.TestAppDelegate") ?? AppDelegate.self
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass!))

/**
 Sets the appearance of the application
 */
private func setAppearance() {
    // Set global colors
    UIView.appearance().tintColor = QColor.blue.color
    UIView.appearance(whenContainedInInstancesOf: [QTableViewCell.self]).tintColor = UIColor.white
    // Remove shadow from bars
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = false
    UITabBar.appearance().shadowImage = UIImage()
    UITabBar.appearance().backgroundImage = UIImage()
    UITabBar.appearance().backgroundColor = UIColor.white
}

/**
 Configures the logger
 */
private func setQlog() {
    QLog.Images.archive = GameIcon.openfolder.tabBarImage
    QLog.Images.live = GameIcon.histogram.tabBarImage
    QLog.Images.supportPackage = GameIcon.cardboardbox.tabBarImage
    QLog.Texts.archive = Texts.archive
    QLog.Texts.live = Texts.live
    QLog.Texts.supportPackage = Texts.supportPackage
    QLog.loggers = [XcodeLogger(), FileLogger(), UiLogger.shared]
    QLog.colorHighlight = QColor.purple.color
    QLog.colorDebug = QColor.blue.color
    QLog.colorInfo = QColor.green.color
    QLog.colorWarning = QColor.yellow.color
    QLog.colorError = QColor.red.color
}

/**
 The "main" function to set some global settings
 */
func main() {
    setAppearance()
    setQlog()
}
