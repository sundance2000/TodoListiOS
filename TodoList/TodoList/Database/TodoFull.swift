//
//  TodoFull.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 20.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Foundation

struct TodoFull: Codable, Equatable {

    let id: Int?
    let desc: String?
    let done: Bool?
    let dueDate: String?
    let title: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case desc = "description"
        case done
        case dueDate
        case title

    }

}
