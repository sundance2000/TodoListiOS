//
//  RootViewCoordinator.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation
import UIKit

protocol RootViewCoontrollerProvider: class {

    var rootViewController: UIViewController { get }

}

typealias  RootViewCoordinator = Coordinator & RootViewCoontrollerProvider
