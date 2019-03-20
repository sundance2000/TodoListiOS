//
//  String.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation

public extension String {

    static fileprivate var rfc3339dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }()

    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    public var rfc3339date: Date? {
        return String.rfc3339dateFormatter.date(from: self)
    }

}
