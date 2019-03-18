//
//  AppCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation
import UIKit

/// Coordinates handling of the app
class AppCoordinator: RootViewCoordinator {

    private let window: UIWindow

    var rootViewController: UIViewController {
        return self.viewController
    }

    private lazy var viewController: UIViewController = {
        return UIViewController()
    }()

    init(window: UIWindow) {
        self.window = window

        self.window.rootViewController = self.rootViewController
    }

    func start() {
        self.window.makeKeyAndVisible()
    }

}
