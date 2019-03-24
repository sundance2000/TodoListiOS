//
//  NetworkService.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 18.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import Alamofire
import Foundation
import QLog
import SwiftyUserDefaults

class NetworkService: Service {

    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    private var url = URL(string: "https://")!

    static var shared = {
        return NetworkService()
    }()

    override var description: String {
        return Strings.ServiceNames.networkService
    }

    private override init() {
    }

    func start() {
        super.start {
            guard let url = URL(string: Defaults[.serverAddress])  else {
                QLogError("Cannot parse server address: \(Defaults[.serverAddress])")
                super.shutdown {}
                return
            }
            self.url = url.appendingPathComponent("todos")
            self.list(state: "all") { statusCode, todoList in
                TodoRepository.shared.save(todoList)
            }
        }
    }

    func shutdown() {
        super.shutdown {
            self.url = URL(string: "https://")!
        }
    }

    private func createJsonRequest(url: URL, httpMethod: HTTPMethod, todoBase: TodoBase) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json;", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? self.jsonEncoder.encode(todoBase)
        return request
    }

    func create(todoBase: TodoBase, actionHandler: @escaping (_ statusCode: Int, _ todoFull: TodoFull) -> Void) {
        let request = self.createJsonRequest(url: self.url, httpMethod: .post, todoBase: todoBase)
        Alamofire.request(request).validate().responseJSON { response in
            guard let statusCode = response.response?.statusCode, let data = response.data else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            guard let todoFull = try? self.jsonDecoder.decode(TodoFull.self, from: data) else {
                QLogError("Cannot parse JSON data \(data)")
                return
            }
            QLogDebug("POST(todoBase: \(todoBase)): Received status code: \(statusCode)")
            guard response.result.isSuccess else {
                QLogError("Error. Server returned \(statusCode)")
                return
            }
            actionHandler(statusCode, todoFull)
        }
    }

    func delete(id: Int32, actionHandler: @escaping (_ statusCode: Int) -> Void) {
        Alamofire.request(self.url.appendingPathComponent(String(id)), method: .delete, headers: ["Accept": "application/json"]).validate().responseJSON { response in
            guard let statusCode = response.response?.statusCode else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            QLogDebug("DELETE(id: \(id)): Received status code: \(statusCode)")
            guard response.result.isSuccess else {
                QLogError("Error. Server returned \(statusCode)")
                return
            }
            actionHandler(statusCode)
        }
    }

    func get(id: Int32, actionHandler: @escaping (_ statusCode: Int, _ todoFull: TodoFull) -> Void) {
        Alamofire.request(self.url.appendingPathComponent(String(id)), method: .get, headers: ["Accept": "application/json"]).validate().responseJSON { response in
            guard let statusCode = response.response?.statusCode, let data = response.data else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            guard let todoFull = try? self.jsonDecoder.decode(TodoFull.self, from: data) else {
                QLogError("Cannot parse JSON data \(data)")
                return
            }
            QLogDebug("GET(id: \(id)): Received(status code: \(statusCode)): \(todoFull)")
            guard response.result.isSuccess else {
                QLogError("Error. Server returned \(statusCode)")
                return
            }
            actionHandler(statusCode, todoFull)
        }
    }

    func list(state: String = "unfinished", limit: Int = 999, offset: Int = 0, actionHandler: @escaping (_ statusCode: Int, _ todoList: [TodoList]) -> Void) {
        Alamofire.request(self.url.absoluteString, method: .get, parameters: ["state": state, "limit": limit, "offset": offset], headers: ["Accept": "application/json"]).validate().responseJSON { response in
            guard let statusCode = response.response?.statusCode, let data = response.data else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            let todoList = (try? self.jsonDecoder.decode([TodoList].self, from: data)) ?? []
            QLogDebug("GET(state: \(state) limit: \(limit) offset: \(offset): Received(status code: \(statusCode)): \(todoList)")
            guard response.result.isSuccess else {
                QLogError("Error. Server returned \(statusCode)")
                return
            }
            actionHandler(statusCode, todoList)
        }
    }

    func update(id: Int32, todoBase: TodoBase, actionHandler: @escaping (_ statusCode: Int) -> Void) {
        let request = self.createJsonRequest(url: self.url.appendingPathComponent(String(id)), httpMethod: .put, todoBase: todoBase)
        Alamofire.request(request).validate().responseJSON { response in
            guard let statusCode = response.response?.statusCode else {
                QLogError("Cannot get data from response \(response)")
                return
            }
            QLogDebug("UPDATE(id: \(id) todoBase: \(todoBase)): Received status code: \(statusCode)")
            guard response.result.isSuccess else {
                QLogError("Error. Server returned \(statusCode)")
                return
            }
            actionHandler(statusCode)
        }
    }

}
