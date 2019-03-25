//
//  Date.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation

public extension Date {

    static fileprivate var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d. M. yyyy"
        return formatter
    }()

    static fileprivate var rfc3339dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }()

    static fileprivate var simpleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()

    var dayString: String {
        return Date.dayFormatter.string(from: self)
    }

    public var rfc3339String: String {
        return Date.rfc3339dateFormatter.string(from: self)
    }

    public var simpleDateString: String {
        return Date.simpleDateFormatter.string(from: self)
    }

}
