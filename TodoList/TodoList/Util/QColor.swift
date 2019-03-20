//
//  QColor.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import UIKit

public enum QColor: String {

    case lightWhite = "lightwhite"
    case white = "white"
    case lightRed = "lightred"
    case red = "red"
    case lightOrange = "lightorange"
    case orange = "orange"
    case lightYellow = "lightyellow"
    case yellow = "yellow"
    case lightGreen = "lightgreen"
    case green = "green"
    case lightBlue = "lightblue"
    case blue = "blue"
    case lightPurple = "lightpurple"
    case purple = "purple"

    public var color: UIColor {
        switch self {
        case .lightWhite:
            return UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
        case .white:
            return UIColor(red: 0.89, green: 0.86, blue: 0.78, alpha: 1.00)
        case .lightRed:
            return UIColor(red: 0.73, green: 0.27, blue: 0.24, alpha: 1.00)
        case .red:
            return UIColor(red: 0.61, green: 0.22, blue: 0.18, alpha: 1.00)
        case .lightOrange:
            return UIColor(red: 0.89, green: 0.60, blue: 0.25, alpha: 1.00)
        case .orange:
            return UIColor(red: 0.82, green: 0.42, blue: 0.26, alpha: 1.00)
        case .lightYellow:
            return UIColor(red: 0.92, green: 0.81, blue: 0.33, alpha: 1.00)
        case .yellow:
            return UIColor(red: 0.92, green: 0.69, blue: 0.25, alpha: 1.00)
        case .lightGreen:
            return UIColor(red: 0.45, green: 0.69, blue: 0.61, alpha: 1.00)
        case .green:
            return UIColor(red: 0.34, green: 0.48, blue: 0.42, alpha: 1.00)
        case .lightBlue:
            return UIColor(red: 0.49, green: 0.64, blue: 0.81, alpha: 1.00)
        case .blue:
            return UIColor(red: 0.16, green: 0.31, blue: 0.58, alpha: 1.00)
        case .lightPurple:
            return UIColor(red: 0.62, green: 0.52, blue: 0.85, alpha: 1.00)
        case .purple:
            return UIColor(red: 0.40, green: 0.30, blue: 0.62, alpha: 1.00)
        }
    }

}
