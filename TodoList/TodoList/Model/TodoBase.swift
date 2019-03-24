//
//  TodoBase.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 19.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation

struct TodoBase: Codable, Equatable {

    let desc: String?
    let done: Bool?
    let dueDate: String?
    let title: String?

    private enum CodingKeys: String, CodingKey {
        case desc = "description"
        case done
        case dueDate
        case title
    }

}
