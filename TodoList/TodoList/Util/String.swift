//
//  String.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation
import QLog

public extension String {

    static fileprivate var rfc3339dateFormatterWithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }()

    static fileprivate var rfc3339dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    public var rfc3339date: Date? {
        var date: Date?
        date = String.rfc3339dateFormatterWithFractionalSeconds.date(from: self)
        if date == nil {
            // Retry without fractional seconds
            date = String.rfc3339dateFormatter.date(from: self)
        }
        guard date != nil else {
            QLogError("Cannot parse date: \(self)")
            return nil
        }
        return date
    }

}
