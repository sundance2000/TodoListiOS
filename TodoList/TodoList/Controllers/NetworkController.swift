//
//  NetworkController.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Alamofire
import Foundation
import QLog

class NetworkController {

    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    private let url = URL(string: "https://todolist.christian-oberdoerfer.de/todos/")!

    static var shared = {
        return NetworkController()
    }()

    private init() {
    }

    func create(todoBase: TodoBase, actionHandler: @escaping (_ statusCode: Int, _ todoFull: TodoFull) -> Void) {
        var request = URLRequest(url: self.url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json;", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? self.jsonEncoder.encode(todoBase)
        Alamofire.request(request).responseJSON { response in
            guard let statusCode = response.response?.statusCode, let data = response.data else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            guard let todoFull = try? self.jsonDecoder.decode(TodoFull.self, from: data) else {
                QLogError("Cannot parse JSON data \(data)")
                return
            }
            QLogDebug("POST(todoBase: \(todoBase)): Received status code: \(statusCode)")
            actionHandler(statusCode, todoFull)
        }
    }

    func delete(id: Int32, actionHandler: @escaping (_ statusCode: Int) -> Void) {
        var request = URLRequest(url: self.url.appendingPathComponent(String(id)))
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json;", forHTTPHeaderField: "Accept")
        Alamofire.request(request).responseJSON { response in
            guard let statusCode = response.response?.statusCode else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            QLogDebug("DELETE(id: \(id)): Received status code: \(statusCode)")
            actionHandler(statusCode)
        }
    }

    func get(id: Int32, actionHandler: @escaping (_ statusCode: Int, _ todoFull: TodoFull) -> Void) {
        var request = URLRequest(url: self.url.appendingPathComponent(String(id)))
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json;", forHTTPHeaderField: "Accept")
        Alamofire.request(request).responseJSON { response in
            guard let statusCode = response.response?.statusCode, let data = response.data else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            guard let todoFull = try? self.jsonDecoder.decode(TodoFull.self, from: data) else {
                QLogError("Cannot parse JSON data \(data)")
                return
            }
            QLogDebug("GET(id: \(id)): Received(status code: \(statusCode)): \(todoFull)")
            actionHandler(statusCode, todoFull)
        }
    }

    func list(state: String = "unfinished", limit: Int = 999, offset: Int = 0, actionHandler: @escaping (_ statusCode: Int, _ todoList: [TodoList]) -> Void) {
        Alamofire.request(self.url.absoluteString, method: .get, parameters: ["state": state, "limit": limit, "offset": offset], headers: ["Accept": "application/json"]).responseJSON { response in
            guard let statusCode = response.response?.statusCode, let data = response.data else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            let todoList = (try? self.jsonDecoder.decode([TodoList].self, from: data)) ?? []
            QLogDebug("GET(state: \(state) limit: \(limit) offset: \(offset): Received(status code: \(statusCode)): \(todoList)")
            actionHandler(statusCode, todoList)
        }
    }

    func update(id: Int32, todoBase: TodoBase, actionHandler: @escaping (_ statusCode: Int) -> Void) {
        var request = URLRequest(url: self.url.appendingPathComponent(String(id)))
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json;", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? self.jsonEncoder.encode(todoBase)
        Alamofire.request(request).responseJSON { response in
            guard let statusCode = response.response?.statusCode else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            QLogDebug("UPDATE(id: \(id) todoBase: \(todoBase)): Received status code: \(statusCode)")
            actionHandler(statusCode)
        }
    }

}
