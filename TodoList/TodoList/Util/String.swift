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

    static fileprivate var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d. M. yyyy"
        return formatter
    }()

    static fileprivate var rfc3339dateFormatterWithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }()

    static fileprivate var rfc3339dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    /**
     Casts the String to a HTTPS URL, if possible.
     If the string does not start with "https://", "https://" is added.
     If the string starts with "http://", "http://" is replaced by "https://".
     */
    var httpsUrl: URL? {
        if self.lowercased().hasPrefix("https://") {
            return URL(string: self)
        } else if self.lowercased().hasPrefix("http://") {
            var temp = self
            temp.removeFirst(7)
            return URL(string: "https://" + temp)
        }
        return URL(string: "https://" + self)
    }

    /**
     Returns the String as localized string
     */
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    var dayDate: Date? {
        guard let date = String.dayFormatter.date(from: self) else {
            QLogError("Cannot parse date: \(self)")
            return nil
        }
        return date
    }

    var rfc3339date: Date? {
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
