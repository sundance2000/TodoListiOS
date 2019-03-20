//
//  String.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation

public extension String {

    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

}
