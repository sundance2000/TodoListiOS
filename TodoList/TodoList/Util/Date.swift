//
//  Date.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation

public extension Date {

    static fileprivate var rfc3339dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }()

    static fileprivate var simpledateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()

    public var rfc3339String: String? {
        return Date.rfc3339dateFormatter.string(from: self)
    }

    public var simpleDateString: String? {
        return Date.simpledateFormatter.string(from: self)
    }

}
