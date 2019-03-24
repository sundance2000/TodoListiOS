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

/**
 The network service for communication with the server
 */
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
            // Read the URL from the preferences
            guard let url = URL(string: Defaults[.serverAddress])  else {
                QLogError("Cannot parse server address: \(Defaults[.serverAddress])")
                super.shutdown {}
                return
            }
            // Set the URL
            self.url = url.appendingPathComponent("todos")
            // Update the list from the server
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

    /**
     Creates a HTTP request with a JSON body
     - parameter url: The target URL
     - parameter httpMethod: The HTTP method
     - parameter todoBase: The TodoBase to encode
     - returns: The URLRequest containing the TodoBase encoded as JSON body
     */
    private func createJsonRequest(url: URL, httpMethod: HTTPMethod, todoBase: TodoBase) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json;", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? self.jsonEncoder.encode(todoBase)
        return request
    }

    /**
     Sends a HTTP POST request to the server to create a new todo
     - parameter todoBase: The TodoBase object containing the information of the new todo
     - parameter actionHandler: The action handler to be called when the request is completed.
     The action handler is only called, if the request was successful.
     - parameter statusCode: The HTTP status code returned by the server
     - parameter todoFull: The TodoFull object returned by the server
     */
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

    /**
     Sends a HTTP DELETE request to the server to delete a todo
     - parameter id: The ID of the todo to delete
     - parameter actionHandler: The action handler to be called when the request is completed.
     The action handler is only called, if the request was successful.
     - parameter statusCode: The HTTP status code returned by the server
     */
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

    /**
     Sends a HTTP GET request to the server to get a todo
     - parameter id: The ID of the todo to get
     - parameter actionHandler: The action handler to be called when the request is completed.
     The action handler is only called, if the request was successful.
     - parameter statusCode: The HTTP status code returned by the server
     - parameter todoFull: The TodoFull object returned by the server
     */
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

    /**
     Sends a HTTP GET request to the server to get a list of todos
     - parameter state: The state of the todos to get.
     Can be "unfinished" to get all todos not done yet
     or "all" to get all todos.
     - parameter limit: The maximum number of todos to get
     - parameter offset: Todos are returned starting with the (offset+1)th element
     - parameter actionHandler: The action handler to be called when the request is completed.
     The action handler is only called, if the request was successful.
     - parameter statusCode: The HTTP status code returned by the server
     - parameter todoList: The array TodoList objects returned by the server
     */
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

    /**
     Sends a HTTP UPDATE request to the server to update an existing todo
     - parameter id: The ID of the todo to update
     - parameter todoBase: The TodoBase object containing the information to update
     - parameter actionHandler: The action handler to be called when the request is completed.
     The action handler is only called, if the request was successful.
     - parameter statusCode: The HTTP status code returned by the server
     */
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
